import XCTest

final class CosmoNoticiasUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    /// 1) Verifica que la lista se carga y navega al detalle del primer artículo.
    func testLoadListAndNavigateToDetail() {
        // Espera a que la tabla exista
        let list = app.tables["ArticlesList"]
        XCTAssertTrue(list.waitForExistence(timeout: 10))
        
        // Toca la primera celda
        let firstCell = list.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.exists)
        firstCell.tap()
        
        // Verifica que aparece la vista de detalle (usando el identifier del título)
        let detailTitle = app.staticTexts["DetailTitle"]
        XCTAssertTrue(detailTitle.waitForExistence(timeout: 5))
    }
    
    /// 2) Verifica la búsqueda y el cancelar vuelve al listado original
    func testSearchAndCancel() {
        let searchField = app.searchFields["buscar"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 5))
        
        // Escribe y busca
        searchField.tap()
        searchField.typeText("SpaceX")
        app.keyboards.buttons["Buscar artículos"].tap()
        
        // Verifica que sale al menos una celda filtrada
        let filteredCell = app.tables.cells.element(boundBy: 0)
        XCTAssertTrue(filteredCell.waitForExistence(timeout: 10))
        
        // Cancela la búsqueda
        let cancelButton = app.buttons["Cancel"]
        if cancelButton.exists {
            cancelButton.tap()
        }
        
        // Ahora debe volver a cargar la lista original
        let originalCell = app.tables.cells.element(boundBy: 0)
        XCTAssertTrue(originalCell.waitForExistence(timeout: 5))
    }
}
