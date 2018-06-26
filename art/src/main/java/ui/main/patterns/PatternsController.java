package ui.main.patterns;

import com.jfoenix.controls.JFXButton;

import data.entities.AccessCondition;
import data.entities.AccessPattern;

import de.jensd.fx.glyphs.materialdesignicons.MaterialDesignIcon;
import de.jensd.fx.glyphs.materialdesignicons.MaterialDesignIconView;

import io.msoffice.excel.AccessPatternImportHelper;

import java.io.File;
import java.util.List;
import java.util.ResourceBundle;
import java.util.Set;

import javafx.beans.binding.Bindings;
import javafx.beans.property.SimpleIntegerProperty;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.scene.control.Alert;
import javafx.scene.control.ButtonBar;
import javafx.scene.control.Label;
import javafx.scene.control.SelectionMode;
import javafx.scene.control.TableCell;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableRow;
import javafx.scene.control.TableView;

import javafx.scene.control.Tooltip;
import javafx.stage.FileChooser;
import javafx.stage.Modality;
import javafx.stage.Stage;
import ui.App;
import ui.AppComponents;
import ui.custom.controls.ButtonCell;
import ui.custom.controls.ConditionTypeCellFactory;
import ui.custom.controls.CustomAlert;
import ui.custom.controls.CustomWindow;
import ui.custom.controls.filter.FilterController;
import ui.main.patterns.modal.PatternImportController;
import ui.main.patterns.modal.PatternsFormController;


public class PatternsController {

    @FXML
    public TableView<AccessPattern> patternsTable;

    @FXML
    public TableColumn<AccessPattern, Set<AccessCondition>> conditionCountColumn;

    @FXML
    public TableColumn<AccessPattern, JFXButton> deleteColumn;

    @FXML
    public TableColumn<AccessPattern, JFXButton> editColumn;

    @FXML
    public TableColumn<AccessPattern, Set<AccessCondition>> conditionTypeColumn;

    @FXML
    public Label itemCount;

    @FXML
    public FilterController filterController;

    private ResourceBundle bundle;
    private SimpleIntegerProperty numberOfItems = new SimpleIntegerProperty();

    /**
     * Initializes the controller.
     */
    @FXML
    public void initialize() throws Exception {

        // load the ResourceBundle
        bundle = ResourceBundle.getBundle("lang");

        // initialize the table
        initializePatternsTable();

        // check if the filters are applied
        filterController.shouldFilterProperty.addListener((o, oldValue, newValue) -> {
            if (newValue) {
                try {
                    updatePatternsTable();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });

        // fill table with all entries from the database
        updatePatternsTable();
    }

    /**
     * Updates the patternsTable items from the database, taking filters into account.
     */
    public void updatePatternsTable() throws Exception {

        List<AccessPattern> patterns = AppComponents.getDbContext().getFilteredPatterns(filterController.showArchivedProperty.getValue(),
            filterController.searchStringProperty.getValue(), filterController.startDateProperty.getValue(),
            filterController.endDateProperty.getValue(), 0);
        ObservableList<AccessPattern> list = FXCollections.observableList(patterns);

        // update itemCount
        numberOfItems.setValue(list.size());

        patternsTable.setItems(list);
        patternsTable.refresh();

    }

    /**
     * Initializes the patterns table.
     */
    private void initializePatternsTable() {

        // replace Placeholder of PatternsTable with other message
        patternsTable.setPlaceholder(new Label(bundle.getString("noEntries")));

        // catch row double click
        patternsTable.setRowFactory(tv -> {
            TableRow<AccessPattern> row = new TableRow<>();
            row.setOnMouseClicked(event -> {
                if (event.getClickCount() == 2 && (!row.isEmpty())) {
                    AccessPattern pattern = row.getItem();
                    openAccessPatternForm(pattern);
                }
            });
            return row;
        });

        // set selection mode to MULTIPLE
        patternsTable.getSelectionModel().setSelectionMode(SelectionMode.MULTIPLE);

        // show an item count (+ selected)
        itemCount.textProperty().bind(Bindings.concat(Bindings.size(patternsTable.getSelectionModel().getSelectedItems()).asString("%s / "),
            numberOfItems.asString("%s " + bundle.getString("selected"))));

        initializeTableColumns();
    }

    /**
     * Initializes the table columns that need extra content.
     */
    private void initializeTableColumns() {

        // Add the delete column
        deleteColumn.setCellFactory(ButtonCell.forTableColumn(MaterialDesignIcon.DELETE, (AccessPattern accessPattern) -> {
            try {
                AppComponents.getDbContext().deletePattern(accessPattern);
                updatePatternsTable();
            } catch (Exception e) {
                e.printStackTrace();
            }
            return accessPattern;
        }));

        // Add the edit column
        editColumn.setCellFactory(ButtonCell.forTableColumn(MaterialDesignIcon.PENCIL, (AccessPattern accessPattern) -> {
            openAccessPatternForm(accessPattern);
            return accessPattern;
        }));

        initializeConditionCountColumn();

        initializeConditionTypeColumn();

    }


    /**
     * Initialize the ConditionCountColumn so it displays the number of conditions of the AccessPattern.
     */
    private void initializeConditionCountColumn() {
        // overwrite the column in which the number of useCases is displayed
        conditionCountColumn.setCellFactory(col -> new TableCell<AccessPattern, Set<AccessCondition>>() {

            @Override
            protected void updateItem(Set<AccessCondition> items, boolean empty) {

                // display nothing if the row is empty, otherwise the item count
                setText((empty || items == null) ? "" : "" + items.size());

            }

        });

        // custom comparator for the conditionCountColumn
        conditionCountColumn.setComparator((list1, list2) -> list1.size() <= list2.size() ? 0 : 1);
    }

    /**
     * Initialize ConditionTypeColumn to show the type of the condition as an icon.
     */
    private void initializeConditionTypeColumn() {

        // sets the icon of the condition to pattern or profile
        conditionTypeColumn.setCellFactory(new ConditionTypeCellFactory());
    }

    /**
     * Opens a modal edit dialog for the selected AccessPattern.
     *
     * @param accessPattern the selected AccessPattern to edit, or null if a new one is created
     */
    public void openAccessPatternForm(AccessPattern accessPattern) {
        try {
            // create a new FXML loader with the SapSettingsEditDialogController
            ResourceBundle bundle = ResourceBundle.getBundle("lang");
            FXMLLoader loader = new FXMLLoader(getClass().getResource("modal/PatternsFormView.fxml"), bundle);
            CustomWindow customWindow = loader.load();

            // build the scene and add it to the stage
            Scene scene = new Scene(customWindow, 1200, 750);
            scene.getStylesheets().add("css/dark-theme.css");
            Stage stage = new Stage();
            stage.setScene(scene);
            stage.initModality(Modality.WINDOW_MODAL);
            stage.initOwner(App.primaryStage);
            customWindow.initStage(stage);

            // set stage name
            if (accessPattern == null) {
                customWindow.setTitle(bundle.getString("newPatternTitle"));
            } else {
                customWindow.setTitle(bundle.getString("editPatternTitle"));
            }

            stage.show();

            // give the dialog the sapConfiguration
            PatternsFormController patternEdit = loader.getController();
            patternEdit.giveSelectedAccessPattern(accessPattern);
            patternEdit.setParentController(this);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Clones the selected entry and adds it to the table.
     */
    public void cloneAction() throws Exception {
        if (patternsTable.getSelectionModel().getSelectedItems() != null && patternsTable.getSelectionModel().getSelectedItems().size() != 0) {

            for (AccessPattern patternToClone : patternsTable.getSelectionModel().getSelectedItems()) {

                AccessPattern clonedPattern = new AccessPattern(patternToClone);
                AppComponents.getDbContext().createPattern(clonedPattern);
            }

            updatePatternsTable();
        }
    }

    /**
     * Opens the edit dialog with the selected item.
     */
    public void editAction() {
        if (patternsTable.getSelectionModel().getSelectedItems() != null && patternsTable.getSelectionModel().getSelectedItems().size() != 0) {
            openAccessPatternForm(patternsTable.getSelectionModel().getSelectedItem());
        }
    }

    /**
     * Deletes the item from the table.
     */
    public void deleteAction() throws Exception {
        if (patternsTable.getSelectionModel().getSelectedItems() != null && patternsTable.getSelectionModel().getSelectedItems().size() != 0) {
            CustomAlert customAlert;
            if (patternsTable.getSelectionModel().getSelectedItems().size() == 1) {
                customAlert = new CustomAlert(Alert.AlertType.CONFIRMATION, bundle.getString("deleteConfirmTitle"),
                    bundle.getString("deleteConfirmMessage"), "Ok", "Cancel");
            } else {
                customAlert = new CustomAlert(Alert.AlertType.CONFIRMATION, bundle.getString("deleteMultipleConfirmTitle"),
                    bundle.getString("deleteMultipleConfirmMessage"), "Ok", "Cancel");
            }

            if (customAlert.showAndWait().get().getButtonData().equals(ButtonBar.ButtonData.OK_DONE)) {
                for (AccessPattern pattern : patternsTable.getSelectionModel().getSelectedItems()) {
                    AppComponents.getDbContext().deletePattern(pattern);
                }
                updatePatternsTable();
            }
        }
    }

    /**
     * Opens the import dialog for AccessPatterns.
     */
    public void importAction() throws Exception {
        FileChooser chooser = new FileChooser();
        chooser.setTitle(bundle.getString("choosePatternFile"));
        //chooser.setInitialDirectory(new File(System.getProperty("user.home")));
        chooser.getExtensionFilters().add(new FileChooser.ExtensionFilter("Pattern Files (*.xlsx)", "*.xlsx"));
        File selectedFile = chooser.showOpenDialog(App.primaryStage);

        if (selectedFile != null) {
            // create a new FXML loader with the SapSettingsEditDialogController
            FXMLLoader loader = new FXMLLoader(getClass().getResource("modal/PatternImportView.fxml"), bundle);
            CustomWindow customWindow = loader.load();

            // build the scene and add it to the stage
            Scene scene = new Scene(customWindow);
            scene.getStylesheets().add("css/dark-theme.css");
            Stage stage = new Stage();
            stage.setScene(scene);
            stage.initModality(Modality.WINDOW_MODAL);
            stage.initOwner(App.primaryStage);
            customWindow.initStage(stage);

            stage.show();

            // import patterns with the AccessPatternImportHelper
            AccessPatternImportHelper importHelper = new AccessPatternImportHelper();
            List<AccessPattern> importedPatterns = importHelper.importAuthorizationPattern(selectedFile.getAbsolutePath());

            // give the dialog the controller and the patterns
            PatternImportController importController = loader.getController();
            importController.giveImportedPatterns(importedPatterns);
            importController.setPatternsController(this);
        }
    }

    /**
     * Opens the modal dialog to create a new item.
     */
    public void addAction() {
        openAccessPatternForm(null);
    }
}
