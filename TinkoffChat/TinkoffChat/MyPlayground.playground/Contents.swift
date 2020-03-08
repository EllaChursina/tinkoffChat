import UIKit

class CEO {
    
    let name: String
    var productManager: ProductManager?
    
    init(name: String) {
        self.name = name
    }
    
    lazy var printManager = { [weak self] in
        print("Hello, I'm \(self?.productManager?.name ?? "%unknown%"), product manager of the Company")
    }
    
    lazy var printDevelopers = { [weak self] in
        self?.productManager?.printDevelopers()
    }
    
    lazy var printCompany = { [weak self] in
        self?.productManager?.printCompany()
    }
    
    deinit {
        print("CEO deinit")
    }
}

class ProductManager {
    
    let name: String
    weak var ceo: CEO?
    var developer1: Developer?
    var developer2: Developer?
    
    init(name: String) {
        self.name = name
    }
    
    func printCompany() {
        print("Hello, I'm \(ceo?.name ?? "%unknown%"), CEO of the Company")
        ceo?.printManager()
        ceo?.printDevelopers()
    }
    
    func printDevelopers() {
        print("Hello, I'm \(developer1?.name ?? "%unknown%"), developer in the Company")
        print("Hello, I'm \(developer2?.name ?? "%unknown%"), developer in the Company")
    }
    
    func findAnotherDeveloper(developer: Developer) -> Developer? {
        if developer === developer1 {
            return developer2
        } else if developer === developer2 {
            return developer1
        } else {
            return nil
        }
    }
    
    deinit {
        print("ProductManager deinit")
    }
}

class Developer {
    let name: String
    weak var productManager: ProductManager?
    
    init(name: String) {
        self.name = name
    }
    
    func conversationBetweenDevelopers(message: String) {
        guard let anotherDeveloper = productManager?.findAnotherDeveloper(developer: self) else {
            print("Another developer don't work in the Company")
            return
        }
        
        print("\(self.name) says \(anotherDeveloper.name): \(message)")
    }
    
    func conversationWithProductManager(message: String) {
        guard let productManager = productManager else {
            print("Product manager don't work in the Company")
            return
        }
        
        print("\(self.name) says \(productManager.name): \(message)")
    }
    
    func conversationWithCEO(message: String) {
        guard let ceo = productManager?.ceo else {
              print("CEO don't work in the Company")
              return
          }
        
        print("\(self.name) says \(ceo.name): \(message)")
    }
    
    deinit {
        print("Developer deinit")
    }
}

class Company {
    
    var ceo: CEO?
    
    func createConversation() {
        print("Company structure:")
        ceo?.printCompany()
        print("Product manager:")
        ceo?.printManager()
        print("Developers:")
        ceo?.printDevelopers()
        print("Conversations:")
        ceo?.productManager?.developer1?.conversationBetweenDevelopers(message: "please, check the task")
        ceo?.productManager?.developer2?.conversationBetweenDevelopers(message: "ok, no problem")
        ceo?.productManager?.developer1?.conversationWithProductManager(message: "i don't have time to finish the task")
        ceo?.productManager?.developer2?.conversationWithCEO(message: "I want a promotion")
        print("Deinit")
    }
    
    deinit {
        print("Company deinit")
    }
}

func createCompany() -> Company {
    let company = Company()
    let ceo = CEO(name: "Maria")
    let productManager = ProductManager(name: "Anna")
    let developer1 = Developer(name: "Alexey")
    let developer2 = Developer(name: "Katerina")
    
    company.ceo = ceo
    
    ceo.productManager = productManager
    
    productManager.ceo = ceo
    productManager.developer1 = developer1
    productManager.developer2 = developer2
    
    developer1.productManager = productManager
    developer2.productManager = productManager
    
    return company
}

func start(){
    let company = createCompany()
    company.createConversation()
}

start()
