import Foundation

//All Constants of the project

//Methods:
let GET = "GET"
let POST = "POST"
let PUT = "PUT"
let DELETE = "DELETE"

// API-URL:
let API_URL = "http://141.51.114.20:8080/"

let HTTP_HEADER_AUTHORIZATION = "Authorization"
let HTTP_HEADER_CONTENT = "Content-type"
let HTTP_APPLICATION_JSON = "application/json"

//Status Codes:
let STATUS_OK = 200
let STATUS_BAD_REQUEST = 400
let STATUS_UNAUTHORIZED = 401
let STATUS_FORBIDDEN = 403
let STATUS_NOT_FOUND = 404
let STATUS_METHOD_NOT_ALLOWED = 405
let STATUS_NOT_ACCEPTABLE = 406
let STATUS_REQUEST_TIMEOUT = 408
let STATUS_CONFLICT = 409
let STATUS_GONE = 410
let STATUS_UNSUPPORTED_MEDIA_TYPE = 415
let STATUS_INTERNAL_SERVER_ERROR = 500
let STATUS_NOT_IMPLEMENTED = 501
let STATUS_BAD_GATEWAY = 502


//Success:
let SUCCESS_UPDATE_USER = "User updated successfully."
let SUCCESS_DELETE_USER = "User deleted successfully."
let SUCCESS_FUNDING = "Funding processed successfully."
let SUCCESS_REFUND = "Purchase refunded successfully."
let SUCCESS_UPLOAD_IMAGE = "Image uploaded successfully."
let SUCCESS_DELETE_IMAGE = "Image deleted successfully."
let SUCCESS_UPDATE_IMAGE = "Image updated successfully."
let SUCCESS_DELETE_ITEM = "Item deleted successfully."
let SUCCESS_UPDATE_ITEM = "Item updated successfully."
let SUCCESS_PURCHASE = "Purchase processed successfully."
let SUCCESS_LOGIN = "Successfully logged in."
let SUCCESS_REGISTER = "Successfully registered."

//Error:
let ERROR_LOGIN = "ID or password incorrect"
let ERROR_TOKEN = "missing token"
let ERROR_NO_IMAGE = "No profile image associated with that ID. (StatusCode: 404)"
let ERROR_USER_EXISTS = "User with that ID already exists."
let ERROR_MONEY = "Not enough money."
let ERROR_FORMAT = "invalid format given"
let ERROR_ITEM_NOT_AVAILABLE = "item currently not available"
let ERROR_NO_ITEM = "no item"

//Key-Chain:
let SERVICE_TOKEN = "access-token"
let SERVICE_PASSWORD = "password"
let ACCOUNT = "Coffe-Booking-System"

//Images:
let IMAGE_LOGIN = "loginCoffeeShop"
let IMAGE_PROFILE = "person"
let IMAGE_NAME = "person.circle"
let IMAGE_HOME = "house"
let IMAGE_CART = "cart"
let IMAGE_QR = "qrcode"
let IMAGE_SEARCH = "magnifyingglass"
let IMAGE_LIST = "list.bullet"
let IMAGE_ARROW_LEFT = "arrow.left"
let IMAGE_NO_PROFILE_IMAGE = "noProfilPicture"
let IMAGE_PENCIL = "pencil"
let IMAGE_PENCIL_EDIT = "pencil.slash"
let IMAGE_ID = "person.text.rectangle"
let IMAGE_EURO = "eurosign.circle"
let IMAGE_PASSWORD = "lock"
let IMAGE_SQUARE = "square"
let IMAGE_SQUARE_MARK = "checkmark.square"
let IMAGE_PLUS = "plus.app"
let IMAGE_PLUS_CIRCLE = "plus.circle"
let IMAGE_MINUS_CIRCLE = "minus.circle"

//Custom Colors:
let COLOR_RED_BROWN = 0xC08267
let COLOR_LIGHT_GRAY = 0xD9D9D9
let COLOR_SEARCH_BAR = 0xE3D5CF
let COLOR_BACKGROUND = 0xCCB9B1

//No Image String
let NO_PROFILE_IMAGE = "empty"

//Transactions
let TRANSACTION_PURCHASE = "purchase"
let TRANSACTION_FUNDING = "funding"
let TRANSACTION_REFUND = "refund"

//Profile Changes
let TYPE_USERNAME = "username"
let TYPE_PASSWORD = "password"
let TYPE_UPLOAD_IMAGE = "image"
let TYPE_DELETE_IMAGE = "deleteImage"
