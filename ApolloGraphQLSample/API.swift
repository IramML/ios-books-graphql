// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public struct BookInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - title
  ///   - author
  public init(title: Swift.Optional<String?> = nil, author: Swift.Optional<String?> = nil) {
    graphQLMap = ["title": title, "author": author]
  }

  public var title: Swift.Optional<String?> {
    get {
      return graphQLMap["title"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "title")
    }
  }

  public var author: Swift.Optional<String?> {
    get {
      return graphQLMap["author"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "author")
    }
  }
}

public final class GetBookQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query GetBook($getBookId: String) {
      getBook(id: $getBookId) {
        __typename
        id
        title
      }
    }
    """

  public let operationName: String = "GetBook"

  public var getBookId: String?

  public init(getBookId: String? = nil) {
    self.getBookId = getBookId
  }

  public var variables: GraphQLMap? {
    return ["getBookId": getBookId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("getBook", arguments: ["id": GraphQLVariable("getBookId")], type: .object(GetBook.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(getBook: GetBook? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "getBook": getBook.flatMap { (value: GetBook) -> ResultMap in value.resultMap }])
    }

    public var getBook: GetBook? {
      get {
        return (resultMap["getBook"] as? ResultMap).flatMap { GetBook(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "getBook")
      }
    }

    public struct GetBook: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Book"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .scalar(String.self)),
          GraphQLField("title", type: .scalar(String.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: String? = nil, title: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Book", "id": id, "title": title])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: String? {
        get {
          return resultMap["id"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var title: String? {
        get {
          return resultMap["title"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "title")
        }
      }
    }
  }
}

public final class HelloQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query Hello {
      hello
    }
    """

  public let operationName: String = "Hello"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("hello", type: .scalar(String.self)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(hello: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "hello": hello])
    }

    public var hello: String? {
      get {
        return resultMap["hello"] as? String
      }
      set {
        resultMap.updateValue(newValue, forKey: "hello")
      }
    }
  }
}

public final class GetBooksQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query GetBooks {
      getAllBooks {
        __typename
        title
        id
      }
    }
    """

  public let operationName: String = "GetBooks"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("getAllBooks", type: .list(.object(GetAllBook.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(getAllBooks: [GetAllBook?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "getAllBooks": getAllBooks.flatMap { (value: [GetAllBook?]) -> [ResultMap?] in value.map { (value: GetAllBook?) -> ResultMap? in value.flatMap { (value: GetAllBook) -> ResultMap in value.resultMap } } }])
    }

    public var getAllBooks: [GetAllBook?]? {
      get {
        return (resultMap["getAllBooks"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [GetAllBook?] in value.map { (value: ResultMap?) -> GetAllBook? in value.flatMap { (value: ResultMap) -> GetAllBook in GetAllBook(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [GetAllBook?]) -> [ResultMap?] in value.map { (value: GetAllBook?) -> ResultMap? in value.flatMap { (value: GetAllBook) -> ResultMap in value.resultMap } } }, forKey: "getAllBooks")
      }
    }

    public struct GetAllBook: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Book"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("title", type: .scalar(String.self)),
          GraphQLField("id", type: .scalar(String.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(title: String? = nil, id: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Book", "title": title, "id": id])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var title: String? {
        get {
          return resultMap["title"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "title")
        }
      }

      public var id: String? {
        get {
          return resultMap["id"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }
    }
  }
}

public final class CreateBookMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation CreateBook($book: BookInput) {
      createBook(book: $book) {
        __typename
        id
        title
      }
    }
    """

  public let operationName: String = "CreateBook"

  public var book: BookInput?

  public init(book: BookInput? = nil) {
    self.book = book
  }

  public var variables: GraphQLMap? {
    return ["book": book]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("createBook", arguments: ["book": GraphQLVariable("book")], type: .object(CreateBook.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(createBook: CreateBook? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "createBook": createBook.flatMap { (value: CreateBook) -> ResultMap in value.resultMap }])
    }

    public var createBook: CreateBook? {
      get {
        return (resultMap["createBook"] as? ResultMap).flatMap { CreateBook(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "createBook")
      }
    }

    public struct CreateBook: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Book"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .scalar(String.self)),
          GraphQLField("title", type: .scalar(String.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: String? = nil, title: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Book", "id": id, "title": title])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: String? {
        get {
          return resultMap["id"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var title: String? {
        get {
          return resultMap["title"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "title")
        }
      }
    }
  }
}

public final class DeleteBookMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation DeleteBook($deleteBookId: String) {
      deleteBook(id: $deleteBookId)
    }
    """

  public let operationName: String = "DeleteBook"

  public var deleteBookId: String?

  public init(deleteBookId: String? = nil) {
    self.deleteBookId = deleteBookId
  }

  public var variables: GraphQLMap? {
    return ["deleteBookId": deleteBookId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("deleteBook", arguments: ["id": GraphQLVariable("deleteBookId")], type: .scalar(String.self)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(deleteBook: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "deleteBook": deleteBook])
    }

    public var deleteBook: String? {
      get {
        return resultMap["deleteBook"] as? String
      }
      set {
        resultMap.updateValue(newValue, forKey: "deleteBook")
      }
    }
  }
}

public final class UpdateBookMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation UpdateBook($updateBookId: String, $updateBookBook: BookInput) {
      updateBook(id: $updateBookId, book: $updateBookBook) {
        __typename
        id
        title
      }
    }
    """

  public let operationName: String = "UpdateBook"

  public var updateBookId: String?
  public var updateBookBook: BookInput?

  public init(updateBookId: String? = nil, updateBookBook: BookInput? = nil) {
    self.updateBookId = updateBookId
    self.updateBookBook = updateBookBook
  }

  public var variables: GraphQLMap? {
    return ["updateBookId": updateBookId, "updateBookBook": updateBookBook]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("updateBook", arguments: ["id": GraphQLVariable("updateBookId"), "book": GraphQLVariable("updateBookBook")], type: .object(UpdateBook.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(updateBook: UpdateBook? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "updateBook": updateBook.flatMap { (value: UpdateBook) -> ResultMap in value.resultMap }])
    }

    public var updateBook: UpdateBook? {
      get {
        return (resultMap["updateBook"] as? ResultMap).flatMap { UpdateBook(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "updateBook")
      }
    }

    public struct UpdateBook: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Book"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .scalar(String.self)),
          GraphQLField("title", type: .scalar(String.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: String? = nil, title: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Book", "id": id, "title": title])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: String? {
        get {
          return resultMap["id"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var title: String? {
        get {
          return resultMap["title"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "title")
        }
      }
    }
  }
}
