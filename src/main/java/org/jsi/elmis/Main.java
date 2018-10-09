package org.jsi.elmis;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Stage;

public class Main extends Application {

    @Override
    public void start(Stage primaryStage) throws Exception{
        Parent root = FXMLLoader.load(getClass().getResource("/Main.fxml"));

        primaryStage.setTitle("Facility Edition Product Standardization");
        primaryStage.setScene(new Scene(root, 400, 300));
        primaryStage.setOnCloseRequest(windowEvent -> {
            System.exit(0);
        });
        primaryStage.show();
    }


    public static void main(String[] args) {
        launch(args);
    }
}
