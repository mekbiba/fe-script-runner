package org.jsi.elmis;

import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.CheckBox;
import javafx.scene.control.PasswordField;
import javafx.scene.control.ProgressIndicator;
import javafx.scene.layout.AnchorPane;
import javafx.scene.layout.VBox;

import java.net.URL;
import java.util.ResourceBundle;

public class Controller implements Initializable {

    @FXML
    private VBox mainContainer;

    @FXML
    private AnchorPane container;
    @FXML
    private Button btnRunScript;
    @FXML
    private ProgressIndicator progressIndicator;

    @FXML
    private CheckBox chkRunAsRoot;
    @FXML
    private PasswordField txtRootPassword;

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        mainContainer.getChildren().remove(txtRootPassword);
        mainContainer.getChildren().remove(chkRunAsRoot);
        /*if(ScriptRunner.getOS().toLowerCase().contains("windows")){
            mainContainer.getChildren().remove(chkRunAsRoot);
        }else{
            mainContainer.getChildren().add(chkRunAsRoot);
            chkRunAsRoot.selectedProperty().addListener((observable, oldValue, newValue) -> {
                if(newValue){
                    Integer insertAtPosition = mainContainer.getChildren().indexOf(chkRunAsRoot);
                    mainContainer.getChildren().add(insertAtPosition, txtRootPassword);
                }else{
                    mainContainer.getChildren().remove(txtRootPassword);
                }
            });
        }

        */
        container.getChildren().remove(0);
        btnRunScript.setOnAction(event -> {
            container.getChildren().add(progressIndicator);
            btnRunScript.setText("Running conversion script...");
            btnRunScript.setDisable(true);
            new Thread( new ScriptRunner(progressIndicator)).start();
        });

    }
}
