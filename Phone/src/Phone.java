import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

import java.util.ArrayList;
import java.util.Locale;
import java.util.ResourceBundle;
import java.util.MissingResourceException;

//package com.sample;

import javax.swing.JOptionPane;
 
import CLIPSJNI.*;

/* Implement FindFact which returns just a FactAddressValue or null */
/* TBD Add size method to PrimitiveValue */


class Phone
  {
   ResourceBundle autoResources;
   Environment clips;
   boolean isExecuting = false;
   Thread executionThread;
      
   Phone()
     {  
        try
        {
         autoResources = ResourceBundle.getBundle("resources.PhoneResources",Locale.getDefault());
        }
        catch (MissingResourceException mre)
        {
         mre.printStackTrace();
         return;
        }
      
      clips = new Environment();
      clips.load("phone.clp");
      clips.reset();
      runProcessing();
     }
     public enum ActionType {
         Next,
         Prev,
         Restart
     } ;
     class Action {
         public ActionType act;
         public String  actCMD;
         public Action(ActionType t,String cmd){
            act = t;
            actCMD = cmd;
         }
     }



   /****************/
   /* nextUIState: */
   /****************/  
   private void nextUIState() throws Exception
     {
      /*=====================*/
      /* Get the state-list. */
      /*=====================*/
      
      String evalStr = "(find-all-facts ((?f state-list)) TRUE)";
      
      String currentID = clips.eval(evalStr).get(0).getFactSlot("current").toString();

      /*===========================*/
      /* Get the current UI state. */
      /*===========================*/
      
      evalStr = "(find-all-facts ((?f UI-state)) " +
                                "(eq ?f:id " + currentID + "))";
      
      PrimitiveValue fv = clips.eval(evalStr).get(0);

      /*=====================*/
      /* Set up the choices. */
      /*=====================*/
            
      PrimitiveValue pv = fv.getFactSlot("valid-answers");
      
      String selected = fv.getFactSlot("response").toString();
      String state = fv.getFactSlot("state").toString();

      QuestionDialog.Title = autoResources.getString("Cellphone");


      ArrayList<Action> actions = new ArrayList<Action>();
      ArrayList<String> options = new ArrayList<String>();

      for (int i = 0; i < pv.size(); i++) 
        {
         PrimitiveValue bv = pv.get(i);
         actions.add(new Action(ActionType.Next,bv.toString()));
         options.add( autoResources.getString(bv.toString()));

        }

         if (state.equals("final"))
         {
             actions.add(new Action(ActionType.Restart,""));
             options.add( autoResources.getString("Restart"));
         }
         else if (state.equals("initial"))
         {
             actions.add(new Action(ActionType.Next,""));
             options.add( autoResources.getString("Next"));
         }
         else
         {
             actions.add(new Action(ActionType.Prev,""));
             options.add( autoResources.getString("Prev"));
         }

         executionThread = null;
         isExecuting = false;
         /*====================================*/
         /* Set the label to the display text. */
         /*====================================*/

         String theText = autoResources.getString(fv.getFactSlot("display").symbolValue());

         String[] optionsArray = new String[options.size()];

         int actino = QuestionDialog.Questions(theText, options.toArray(optionsArray) );
         if(actino == -1){
             System.exit(0);
         }

         System.out.println(actions.get(actino).actCMD);

         onActionPerformed(actions.get(actino));
     }


 
   /***********/
   /* runProcessing */
   /***********/  
   public void runProcessing()
     {
      Runnable runThread = 
         new Runnable()
           {
            public void run()
              {
               clips.run();
               
               SwingUtilities.invokeLater(
                  new Runnable()
                    {
                     public void run()
                       {
                        try 
                          { nextUIState(); }
                        catch (Exception e)
                          { e.printStackTrace(); }
                       }
                    });
              }
           };
      
      isExecuting = true;
      
      executionThread = new Thread(runThread);
      
      executionThread.start();
     }

      public void onActionPerformed(
              Action action) throws Exception
      {
          if (isExecuting) return;

          /*=====================*/
          /* Get the state-list. */
          /*=====================*/

          String evalStr = "(find-all-facts ((?f state-list)) TRUE)";

          String currentID = clips.eval(evalStr).get(0).getFactSlot("current").toString();

          /*=========================*/
          /* Handle the Next button. */
          /*=========================*/

          if (action.act == ActionType.Next)
          {
              if (action.actCMD.equals(""))
              { clips.assertString("(next " + currentID + ")"); }
              else
              {
                  clips.assertString("(next " + currentID + " " +
                          action.actCMD +
                          ")");
              }

              runProcessing();
          }
          else if (action.act == ActionType.Restart)
          {
              clips.reset();
              runProcessing();
          }
          else if (action.act == ActionType.Prev)
          {
              clips.assertString("(prev " + currentID + ")");
              runProcessing();
          }
      }



   public static void main(String args[])
     {  
      // Create the frame on the event dispatching thread.

         //JFrame jfrm = new JFrame("Cellphone");
         //jfrm.setVisible(true);



      SwingUtilities.invokeLater(
        new Runnable() 
          {  
           public void run() { new Phone(); }
          });   
     }
    public static class QuestionDialog {
        public static  String Title = "TestTitle";
        public static int Questions(String question,String[] answers){
            final int[] res = {-1};
            JDialog dialog = null;

            JOptionPane optionPane = new JOptionPane();
            optionPane.setMessage(question);
            optionPane.setMessageType(JOptionPane.QUESTION_MESSAGE);

            JPanel panel = new JPanel();
            panel.setLayout(new GridLayout(answers.length,1));
            JButton[] buttons = new JButton[answers.length];
            for (int i = 0; i < answers.length; i++)
            {
                buttons[i] = new JButton(answers[i]);
                panel.add(buttons[i]);
            }
            optionPane.setOptionType(JOptionPane.DEFAULT_OPTION);
            optionPane.remove(1);
            optionPane.add(panel,1);

            dialog = optionPane.createDialog(null, Title);

            final JDialog dj = dialog;
            for (int i = 0; i < answers.length; i++)
            {
                final int e = i;
                buttons[i].addActionListener(new ActionListener() {
                    @Override
                    public void actionPerformed(ActionEvent et) {
                        res[0] = e;
                        System.out.println(res[0]);
                        dj.setVisible(false);
                    }
                });
            }

            dialog.setVisible(true);


            return res[0];
        }
    }
  }
