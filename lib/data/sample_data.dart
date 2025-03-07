import '../models/product.dart';
import '../models/education_content.dart';

class SampleData {
  static List<Product> getProducts() {
    return [
      Product(
        id: 1,
        name: 'Premium Dry Dog Food',
        description:
            'High-quality dog food with balanced nutrition for adult dogs. Made with real chicken and vegetables.',
        price: 49.99,
        imageUrl: 'assets/images/dog_food.jpg',
        rating: 4.8,
        reviewCount: 245,
        category: 'Dry Food',
      ),
      Product(
        id: 2,
        name: 'Salmon Oil Supplement',
        description:
            'Omega-3 rich salmon oil to support healthy skin and coat for your dog.',
        price: 24.99,
        imageUrl: 'assets/images/salmon_oil.jpg',
        rating: 4.6,
        reviewCount: 128,
        category: 'Supplements',
      ),
      Product(
        id: 3,
        name: 'Grain-Free Wet Dog Food',
        description:
            'Grain-free wet food made with real beef and vegetables. No artificial preservatives.',
        price: 3.99,
        imageUrl: 'assets/images/wet_food.jpg',
        rating: 4.5,
        reviewCount: 187,
        category: 'Wet Food',
      ),
      Product(
        id: 4,
        name: 'Senior Dog Multivitamin',
        description:
            'Complete vitamin supplement designed for senior dogs to support joint health and immunity.',
        price: 29.99,
        imageUrl: 'assets/images/vitamin.jpg',
        rating: 4.7,
        reviewCount: 103,
        category: 'Supplements',
      ),
    ];
  }

  static List<EducationContent> getEducationContent() {
    return [
      EducationContent(
        id: 1,
        title: 'Understanding Dog Nutrition Basics',
        summary:
            'Learn the fundamentals of canine nutrition and how to feed your dog properly.',
        content:
            'Dogs require a balanced diet that includes proteins, carbohydrates, fats, vitamins, and minerals. Proteins are essential for muscle development and repair. High-quality animal proteins like chicken, beef, fish, and eggs are excellent sources. Carbohydrates provide energy and should come from digestible sources like rice, oats, and vegetables. Fats are concentrated energy sources that also support cell function and nutrient absorption. Essential fatty acids like omega-3 and omega-6 are particularly important for skin and coat health. A balanced diet should include appropriate amounts of vitamins and minerals, either naturally occurring in foods or through supplements when necessary. Always ensure your dog has access to fresh, clean water. The exact nutritional needs vary based on age, breed, size, activity level, and health status.',
        imageUrl: 'assets/images/nutrition_basics.jpg',
        category: 'Nutrition Basics',
      ),
      EducationContent(
        id: 2,
        title: 'Feeding Puppies: A Complete Guide',
        summary:
            'Everything you need to know about puppy nutrition for healthy development.',
        content:
            'Puppies have different nutritional needs than adult dogs. They require more calories, protein, and certain minerals to support their rapid growth. Puppy food is specifically formulated with these needs in mind. For most breeds, puppies should be fed 3-4 times daily until about 6 months of age, then transition to 2-3 meals daily. Large and giant breeds may need special puppy formulas to prevent too-rapid growth, which can lead to skeletal problems. When selecting puppy food, look for products that meet AAFCO standards for growth. The transition from mother\'s milk to solid food should be gradual, starting around 3-4 weeks with a gruel made from puppy kibble soaked in warm water or puppy milk replacer. By 7-8 weeks, puppies should be fully weaned and eating solid food. Monitor your puppy\'s weight and body condition regularly, adjusting portion sizes as needed to maintain healthy growth.',
        imageUrl: 'assets/images/puppy_feeding.jpg',
        category: 'Puppy Care',
      ),
      EducationContent(
        id: 3,
        title: 'Managing Weight in Adult Dogs',
        summary:
            'Tips and strategies to maintain a healthy weight for your adult dog.',
        content:
            'Maintaining a healthy weight is crucial for your dog\'s overall health and longevity. Obesity in dogs can lead to arthritis, diabetes, heart disease, and reduced lifespan. To manage your dog\'s weight effectively, start by determining their ideal weight based on breed standards and body condition. Your veterinarian can help assess this. Measure food portions precisely rather than estimating, and adjust calorie intake based on activity level, metabolism, and age. Regular exercise is essential—aim for at least 30 minutes daily, adjusting for your dog\'s breed, age, and health status. Treats should make up no more than 10% of your dog\'s daily caloric intake. Consider using healthy, low-calorie options like carrot pieces or commercial diet treats. Regular weigh-ins, either at home or at your vet\'s office, help track progress and allow for timely adjustments to your dog\'s diet and exercise plan.',
        imageUrl: 'assets/images/weight_management.jpg',
        category: 'Adult Dog Care',
      ),
      EducationContent(
        id: 4,
        title: 'Dietary Considerations for Senior Dogs',
        summary:
            'How to adjust your older dog\'s diet to support health and longevity.',
        content:
            'As dogs age, their nutritional needs change. Senior dogs generally have slower metabolisms and may need fewer calories to prevent weight gain. However, they often require higher quality protein to maintain muscle mass, and may benefit from additional joint-supporting nutrients like glucosamine and chondroitin. Seniors may also need more easily digestible food, especially if dental issues make chewing difficult. Many senior dogs benefit from increased fiber to support digestive health and prebiotics to maintain gut flora balance. Cognitive function can be supported with diets containing antioxidants, omega-3 fatty acids, and medium-chain triglycerides. Some seniors develop medical conditions requiring special diets, such as kidney, liver, or heart disease. Always consult with your veterinarian before making significant changes to your senior dog\'s diet, especially if they have existing health conditions. Regular veterinary check-ups become even more important in the senior years to catch and address nutritional deficiencies or health issues early.',
        imageUrl: 'assets/images/senior_nutrition.jpg',
        category: 'Senior Dog Care',
      ),
    ];
  }
}
