package org.jsi.elmis;

import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.ProgressIndicator;
import javafx.scene.layout.AnchorPane;

import java.net.URL;
import java.util.ResourceBundle;

public class Controller implements Initializable {
    @FXML
    private AnchorPane container;
    ProgressIndicator progressIndicator = new ProgressIndicator();

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        container.getChildren().add(progressIndicator);
        new Thread( new ScriptRunner(progressIndicator)).start();
    }
}
