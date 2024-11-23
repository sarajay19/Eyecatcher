//
//  Labeling.swift
//  Eyecatcher
//
//  Created by Sara AlQuwaifli on 19/05/2024.
//

import Foundation
import SwiftUI

class Labeling{
    private var labelColors: [String: CGColor] = [:]
    @State private var detectedLabel: String = ""
    @Published var mostProminentLabel: String = ""
        
        // translations
        // translations
    var translations: [String: [String: String]] = [
            "English": [
                "person": "person", "cat": "Cat", "dog": "Dog", "horse": "Horse", "sheep": "Sheep", "cow": "Cow",
                "elephant": "Elephant", "bear": "Bear", "zebra": "Zebra", "giraffe": "Giraffe", "bicycle": "Bicycle",
                "car": "Car", "motorcycle": "Motorcycle", "airplane": "Airplane", "bus": "Bus", "train": "Train",
                "truck": "Truck", "boat": "Boat", "traffic light": "Traffic Light", "fire hydrant": "Fire Hydrant",
                "stop sign": "Stop Sign", "parking meter": "Parking Meter", "bench": "Bench", "bird": "Bird",
                "backpack": "Backpack", "umbrella": "Umbrella", "handbag": "Handbag", "tie": "Tie", "suitcase": "Suitcase",
                "frisbee": "Frisbee", "skis": "Skis", "snowboard": "Snowboard", "sports ball": "Sports Ball", "kite": "Kite",
                "baseball bat": "Baseball Bat", "baseball glove": "Baseball Glove", "skateboard": "Skateboard",
                "surfboard": "Surfboard", "tennis racket": "Tennis Racket", "bottle": "Bottle", "wine glass": "Wine Glass",
                "cup": "Cup", "fork": "Fork", "knife": "Knife", "spoon": "Spoon", "bowl": "Bowl", "banana": "Banana",
                "apple": "Apple", "sandwich": "Sandwich", "orange": "Orange", "broccoli": "Broccoli", "carrot": "Carrot",
                "hot dog": "Hot Dog", "pizza": "Pizza", "donut": "Donut", "cake": "Cake", "chair": "Chair", "couch": "Couch",
                "potted plant": "Potted Plant", "bed": "Bed", "dining table": "Dining Table", "toilet": "Toilet", "tv": "TV",
                "laptop": "Laptop", "mouse": "Mouse", "remote": "Remote", "keyboard": "Keyboard", "cell phone": "Cell Phone",
                "microwave": "Microwave", "oven": "Oven", "toaster": "Toaster", "sink": "Sink", "refrigerator": "Refrigerator",
                "book": "Book", "clock": "Clock", "vase": "Vase", "scissors": "Scissors", "teddy bear": "Teddy Bear",
                "hair drier": "Hair Drier", "toothbrush": "Toothbrush"
            ],
            "Arabic": [
                "person": "شخص", "cat": "قط", "dog": "كلب", "horse": "حصان", "sheep": "خروف", "cow": "بقرة",
                "elephant": "فيل", "bear": "دب", "zebra": "حمار وحشي", "giraffe": "زرافة", "bicycle": "دراجة",
                "car": "سيارة", "motorcycle": "دراجة نارية", "airplane": "طائرة", "bus": "حافلة", "train": "قطار",
                "truck": "شاحنة", "boat": "قارب", "traffic light": "إشارة مرور", "fire hydrant": "صنبور حريق",
                "stop sign": "علامة توقف", "parking meter": "عداد الركن", "bench": "مقعد", "bird": "طائر",
                "backpack": "حقيبة ظهر", "umbrella": "مظلة", "handbag": "حقيبة يد", "tie": "ربطة عنق", "suitcase": "حقيبة سفر",
                "frisbee": "قرص طائر", "skis": "زلاجات", "snowboard": "لوح تزلج", "sports ball": "كرة رياضية", "kite": "طائرة ورقية",
                "baseball bat": "مضرب بيسبول", "baseball glove": "قفاز بيسبول", "skateboard": "لوح تزلج", "surfboard": "لوح ركوب الأمواج",
                "tennis racket": "مضرب تنس", "bottle": "زجاجة", "wine glass": "كأس نبيذ", "cup": "كوب", "fork": "شوكة",
                "knife": "سكين", "spoon": "ملعقة", "bowl": "وعاء", "banana": "موز", "apple": "تفاح", "sandwich": "سندويش",
                "orange": "برتقال", "broccoli": "بروكلي", "carrot": "جزر", "hot dog": "هوت دوج", "pizza": "بيتزا",
                "donut": "دونات", "cake": "كعكة", "chair": "كرسي", "couch": "أريكة", "potted plant": "نبتة محفوظة",
                "bed": "سرير", "dining table": "طاولة طعام", "toilet": "مرحاض", "tv": "تلفزيون",
                "laptop": "كمبيوتر محمول", "mouse": "فأرة", "remote": "جهاز تحكم", "keyboard": "لوحة مفاتيح",
                "cell phone": "هاتف محمول", "microwave": "ميكروويف", "oven": "فرن", "toaster": "محمصة", "sink": "مغسلة",
                "refrigerator": "ثلاجة", "book": "كتاب", "clock": "ساعة", "vase": "مزهرية", "scissors": "مقص",
                "teddy bear": "دمية دب", "hair drier": "مجفف شعر", "toothbrush": "فرشاة أسنان"
            ]
        ]
    
    
    
    init(){
        self.labelColors = self.generateLabelColors()
    }
    
    func labelImage(image: UIImage, observations: [ProcessedObservation], language: String, shouldLabel: Bool) -> UIImage? {
            UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
            image.draw(at: CGPoint.zero)
            let context = UIGraphicsGetCurrentContext()!

            for observation in observations {
                let labelColor = labelColors[observation.label] ?? UIColor.black.cgColor
                drawBox(context: context, bounds: observation.boundingBox, color: labelColor)
                if shouldLabel {
                    let label = translate(label: observation.label, to: language)
                    let textBounds = getTextRect(bigBox: observation.boundingBox)
                    drawBox(context: context, bounds: observation.boundingBox, color: labelColor)
                    drawTextBox(context: context, drawText: label, bounds: textBounds, color: labelColor)
                    mostProminentLabel = label
                }
            }
       // print("mostProminentLabel: \(mostProminentLabel)")

            let modifiedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return modifiedImage
        }
    
    func translate(label: String, to language: String) -> String {

              return translations[language]?[label] ?? label
          }
    
    
    func drawBox(context: CGContext, bounds: CGRect, color: CGColor) {
        // the stroke color
        guard let backgroundColor = color.copy(alpha: 0.6) else {
            return
        }
        context.setStrokeColor(backgroundColor)
        
        // the line width
        context.setLineWidth(bounds.height * 0.009)
        
        // the line dash pattern
        context.setLineDash(phase: 0, lengths: [70, 60])

        // Create the rounded rectangle path
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.height * 0.05)
        context.addPath(path.cgPath)
        context.drawPath(using: .stroke)
    }
    
    func getTextRect(bigBox:CGRect) -> CGRect{
        let width = bigBox.width
        let height = bigBox.height*0.10
        let yOffset: CGFloat = 50.0 // Adjust this value to change the spacing
            return CGRect(x: bigBox.minX, y: bigBox.maxY + yOffset, width: width, height: height)
    }
    
    func drawTextBox(context: CGContext, drawText text: String, bounds: CGRect, color: CGColor) {
        // Text box background
        guard let backgroundColor = color.copy(alpha: 0.6) else {
            return
        }
        context.setFillColor(backgroundColor)

        // Create the rounded rectangle path
        let cornerRadius: CGFloat = 30.0
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        context.addPath(path.cgPath)
        context.drawPath(using: .fill)

        // Text
        let textColor = UIColor.white
        let textFont = UIFont(name: "Helvetica-bold", size: 80)!

        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor
        ] as [NSAttributedString.Key: Any]

        text.draw(in: bounds.offsetBy(dx: bounds.width * 0.05, dy: bounds.height * 0.05), withAttributes: textFontAttributes)
    }
    
    let labels = ["person", "bicycle", "car", "motorcycle", "airplane", "bus", "train", "truck", "boat", "traffic light", "fire hydrant", "stop sign", "parking meter", "bench", "bird", "cat", "dog", "horse", "sheep", "cow", "elephant", "bear", "zebra", "giraffe", "backpack", "umbrella", "handbag", "tie", "suitcase", "frisbee", "skis", "snowboard", "sports ball", "kite", "baseball bat", "baseball glove", "skateboard", "surfboard", "tennis racket", "bottle", "wine glass", "cup", "fork", "knife", "spoon", "bowl", "banana", "apple", "sandwich", "orange", "broccoli", "carrot", "hot dog", "pizza", "donut", "cake", "chair", "couch", "potted plant", "bed", "dining table", "toilet", "tv", "laptop", "mouse", "remote", "keyboard", "cell phone", "microwave", "oven", "toaster", "sink", "refrigerator", "book", "clock", "vase", "scissors", "teddy bear", "hair drier", "toothbrush"]
    
    func generateLabelColors() -> [String: CGColor] {
        var labelColor: [String: CGColor] = [:]
        
        if let orangeColor = UIColor(named: "Orange")?.cgColor {
                for label in self.labels {
                    labelColor[label] = orangeColor
                }
            }
        
        return labelColor
    }
    
}

