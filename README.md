# Footballer’s Valuation: Predicting Rise/Fall in Valuations of Footballers 
## Using Different Machine Learning Methodologies to Predict the Changes in the Market Valuations of Football Players playing from 2015 to 2023
### Mahdi Munshi and Vaibhav Agarwal

## Abstract

The valuation of football players is an integral part of professional football management, influencing decisions on player transfers and team strategies. Traditionally reliant on subjective assessments, the industry has seen a shift towards data-driven methodologies due to the increasing availability of detailed player performance data. This project explores the application of machine learning (ML) techniques to predict changes in player valuations, addressing the dynamic and complex nature of the factors that influence these valuations. By utilizing data from 2016 to 2023, the project applies Random Forests, Support Vector Machines (SVMs), and Neural Networks to a dataset of players active throughout these eight seasons. The objective is to identify patterns and predict future valuation trends, demonstrating the potential of ML to enhance decision-making in sports management. The results are expected to show that ML models can adapt to the variable influences across different football contexts, providing more accurate and nuanced predictions than traditional methods. This project not only contributes to the strategic management of sports teams but also illustrates the broader applicability of ML in transforming industry practices.

## Dataset

To circumvent the complexities of web scraping and APIs and ensure the reliability of our dataset, we opted to use a pre-compiled dataset available on Kaggle. This dataset, sourced from Transfermarkt, provides a comprehensive and up-to-date compilation of football data, including detailed player valuations. It encompasses a wide array of variables that are critical for our analysis, enabling a more nuanced exploration of factors influencing player valuations. The dataset’s breadth and depth ensure that our machine learning models are trained and tested on good and relevant data.

## Implementation of SVM and Random Forest Models
### Support Vector Machines (SVM)
The Support Vector Machine model was implemented to predict the trend in market values of football players—whether they would rise, fall, or remain the same. Initially, the dataset underwent preprocessing where categorical variables were transformed into dummy variables and missing values were imputed. A significant step in preparing the data involved scaling the features using StandardScaler to ensure that the SVM model, which is sensitive to the scale of input features, could perform optimally.
The model was trained using a linear kernel to maintain model simplicity and interpretability, given the high dimensionality of the data. The SVM was set up with a probability estimation enabled, which is crucial for assessing the confidence of the predictions. The scikit-learn library's SVC class was employed with a linear kernel and the probability calculation enabled. This approach was pivotal in predicting the market value trends categorized into 'Fall', 'Same', or 'Rise'. After processing and scaling the features, the dataset was split into training and testing sets, maintaining a stratified distribution of the outcome variable to ensure that each split represented the overall dataset proportionally. The model's performance was evaluated using a confusion matrix and classification reports, highlighting an accuracy of 84%, with the model performing exceptionally well in identifying 'Rise' trends but showing room for improvement in predicting 'Same' categories.

|       | precision | recall    | f1-score | support | 
| :---        |    :----:   |          ---: |   :----:   |          ---: |
| Fall      | 0.82       | 0.89   |   0.85  |          1050|
| Rise   | 1.00      | 1.00   |  1.00 |         708 |
 | Same       | 0.33       | 0.22  |   0.26  |         266 |
|    |         |        |     |           |
| accuracy      |        |    |   0.84   |          2024 |
| macro avg   | 0.72        | 0.70      |  0.70   |          2024 |
| weighted avg  | 0.82        | 0.84      |  0.83   |          2024 |
 

 ![image](https://github.com/econvaibhav/ML-Predictor-Underdogs-EuropeanFootball/assets/126394404/96f401f8-cba4-4bbd-9b7c-01a1e4991257)


The confusion matrix displayed illustrates the performance of the SVM model used to predict market valuation trends for football players. The model showed strong predictive capabilities, particularly in identifying players whose market values were predicted to rise or fall, with accuracy rates of 100% for the 'Rise' category and about 89% for the 'Fall' category. However, the model struggled with the 'Same' category, accurately predicting only 58 instances correctly while misclassifying 208 cases as 'Fall'.

### Random Forest Implementation
Concurrently, a Random Forest classifier was employed to leverage its ensemble learning technique, which integrates multiple decision trees to improve prediction accuracy and control over-fitting. Before fitting the model, missing values in the dataset were handled using median imputation through ‘SimpleImputer’.
Through the package ‘RandomForestClassifier’ from scikit-learn, the Random Forest model was configured with 100 estimators, providing a good balance between computational efficiency and model performance. After training, the model's feature importance was analyzed, revealing which attributes most significantly influenced the predictions. The top 3 factors that were most important to the predictions were a) if the player plays for a club that is in one of the top 5 major leagues, b) the win percentage of that player for a single year, and c) if the player’s values were increased in the previous year compared to the year before that.
 
![image](https://github.com/econvaibhav/ML-Predictor-Underdogs-EuropeanFootball/assets/126394404/d9f50f0b-2026-43d9-957e-7275d2f380e2)


### Implementation of Neural Networks 
Building upon our learning objective of hands-on learning, we decided to attempt creating a neural network model. The goal of this model was to train a binary classifier to predict, given player stats and meta-data from the previous year, whether his valuation will increase in the subsequent year. The main variable in this case was ‘value_increase’, which took the value 1, if the player valuation increased.  Before proceeding with the working on the data for training, the dataset was converted into binary dataset so that it can be fed to the model. 
Next, the data was split into features (X) and the target variable (y). The features included all columns except the target column ‘value_increase’. The data was then split into training and testing sets using ‘train_test_split’; reserving 20% of the data for testing. Additionally, based on recommendations from a few LLMs, we applied feature scaling to normalize the feature data, ensuring that all features contribute equally to the model training process by converting them into a common scale without distorting differences in the range of values. 

A sequential model is defined using ‘Sequential()’ , i.e., to stack layers in a sequence to build a neural network model in TensorFlow. Based on aid from LLMs, we examined the functioning and theoretical background behind the model we were training. The model comprises several layers – where each dense layer is a fully connected layer where each neuron receives input from all neurons of the previous layer. The model also includes dropout layers to prevent overfitting by randomly setting a fraction of input units to 0 at each update during training time building a more robust model. 
Finally, the model is compiled with the adam optimizer, an optimizer that adapts the learning rate during training. ‘binary_crossentropy’ is used as the loss function. With this done , ‘model.fit()’ trains the model for 50 epochs. 
Here are some insights into the model evaluation: 

|       | precision | recall    | f1-score | support | 
| :---        |    :----:   |          ---: |   :----:   |          ---: |
| 0 (no value increase)     | 0.80       | 0.89   |   0.84  |          1590|
| 1  (value increase) | 0.68     | 0.52   |  0.59 |         727 |
|    |         |        |     |           |
| accuracy      |        |    |   0.77   |          2317 |
| macro avg   | 0.74        | 0.70      |  0.72   |          2317 |
| weighted avg  | 0.76        | 0.77      |  0.76  |          2317 |


 ![image](https://github.com/econvaibhav/ML-Predictor-Underdogs-EuropeanFootball/assets/126394404/117467c3-74fc-4ba4-8b97-4fc887d9aba1)

	
The table and confusion matrix above highlight some class-specific metrics. These include precision, recall, f1socre (a combination of precision and recall) and sample size. Looking at the sample there can be a case of class imbalance; however, that has not been checked for this project. We can see that the model performs decently for both the classes; however, it shows a stronger performance in detecting the negative class (0) compared to the positive class (1). Given that the recall for class 1 is significantly lower, the model struggles with false negatives for the positive class – we can see this from the confusion matrix as well. The diagonals which indicate correct identification are strong for class 0; however, the model has trouble correctly predicting where a player will receive an increased valuation next year. This model is not strong enough to predict changes in player valuations and requires further tuning, possibly more features as well as stronger focus on the problem of class imbalance. 
Despite the model requiring greater fine tuning efforts, it achieved a high accuracy for the training data. This allows us to interpret the top features which hold the greatest importance in predicting whether a player will receive higher valuation or not. With some expectations, we can see that the results are similar to that of SVMs. Factors such as high win rate, being a right footed footballer (surprisingly), your experience, whether you play in a major league and how much play time you get each match, help decide the changes in player valuations the most.
 
![image](https://github.com/econvaibhav/ML-Predictor-Underdogs-EuropeanFootball/assets/126394404/ae41e379-b457-4300-9190-9dd78f34a5cb)


### Implementation of Convolutional Neural Network (CNN) 
Working towards our learning objectives from this course and taking inspiration from Anton Berg’s masters thesis – ‘Can a deep neural network predict the political affiliation from facial images of Finnish left and right-wing politicians?’, we decided to use a similar methodology to predict which position a footballer plays for, based on their facial images. Based on image urls, we extracted the images of the footballers and saved them on our personal google drive account. 
The images were downloaded based on their position (Attacker, Defender, Mid-Field and Goal Keeper) and their sub-positions, for a total of 13 classes. Alongside downloading the images, the images are rescalled to  normalize pixel values and a validation split 35% of the data for validation is set. Due to a large number of images available, only ⅓ of the data is used; the remaining is left for future training purposes or attempting a k-fold testing system. A separate directory on google drive was created for each image category as the classes are extracted based on the folder names.  

Before working on the model architecture, it is important to remove the default avatar images from the dataset. For this purpose images with lower edges and high contrast are identified; however, this does not lead to accurate results as some players with default avatars are filtered out. 

 ![image](https://github.com/econvaibhav/ML-Predictor-Underdogs-EuropeanFootball/assets/126394404/7e11f9ea-0ca3-4f96-9098-1faedcc72fe8)


After refining the edges and contrast parameter further, only the default avatars were identified and removed. 
![image](https://github.com/econvaibhav/ML-Predictor-Underdogs-EuropeanFootball/assets/126394404/ff78a4be-83ca-45b7-b737-cd745d9fd7c9)

 ![image](https://github.com/econvaibhav/ML-Predictor-Underdogs-EuropeanFootball/assets/126394404/a315a5fd-199d-4140-887a-bd9331368d94)

 

With a cleaner dataset, the model is a convolutional neural network architecture optimized for image classification is selected. It starts with an input tensor to handle images of 150x150 pixels with three color channels (RGB) is created as the first layer. This can help identify broader patterns. Moving on, the core of the model includes three convolutional layers paired with max pooling layers for extracting and downsizing features from images.
A Flatten layer converts the 2D feature maps into a 1D array. A final dense layer which makes use of a softmax activation function tailored to output probabilities across the multiple classes is used. The model is compiled with the adam optimizer, which adjusts learning rates over training, and the categorical_crossentropy loss function, since we shifted to a multi-class model instead of a binary classifier. Training is conducted over 10 epochs. The updated results, after the presentation, look less promising. The model has persistent low accuracy, despite the large training time (approximately 4 hrs).  The confusion matrix illustrates the problem faced by the model –This problem persists despite attempts to neutralize the class imbalance and adding  class weights. The older model was trained on unclead image data which data plenty of default images, resulting in a possibility of higher model accuracy. To train the model further will require greater time and understanding of the CNN framework. In the future, we can try to model a binary image classifier (example: whether the footballer is a striker or not, plays in the major league or not etc.)

 
![image](https://github.com/econvaibhav/ML-Predictor-Underdogs-EuropeanFootball/assets/126394404/a1a40d92-357a-444e-89c5-012a15c22b51)
![image](https://github.com/econvaibhav/ML-Predictor-Underdogs-EuropeanFootball/assets/126394404/9f92aab9-fa3b-4268-b353-09603852e534)
![image](https://github.com/econvaibhav/ML-Predictor-Underdogs-EuropeanFootball/assets/126394404/8569dbaa-2d1f-4367-bb35-35ab5e11846d)



## Discussion and Conclusion
The project’s results underline the potential of machine learning models in enhancing the predictability of football player valuations. The SVM model’s high precision in identifying rising valuations suggests it could be particularly useful in scenarios where the cost of false positives is high. However, its lower performance on the 'Same' category could be attributed to the fewer instances of this class in the dataset, a common challenge in imbalanced datasets.
The Random Forest model’s ability to provide a detailed feature importance analysis helps in understanding the driving factors behind player valuations. This could be incredibly beneficial for football clubs and sports analysts in refining their evaluation metrics.
The neural network's performance indicates its capability to model complex patterns and interactions among variables, although it requires more fine-tuning to handle class imbalances effectively, which were evident in the lower recall for the positive class.
These results demonstrate that while machine learning can significantly enhance the accuracy of predicting player valuations, attention must be given to model selection based on the specific characteristics of the data and the prediction task at hand.
This project set out to explore the efficacy of machine learning techniques in predicting football players’ market valuations and demonstrated that these models could provide substantial improvements over traditional methods. The integration of Random Forests, SVM, and Neural Networks provided a decent understanding of the factors influencing player valuations and their predictive power.
In future, we should focus on addressing the limitations identified, such as the imbalance in the dataset and enhancing the models’ architecture to better generalize across different player profiles. Additionally, incorporating more granular data, such as minute-level performance metrics or psychometric data, could further refine the models' predictions.
In conclusion, this project highlights the transformative potential of machine learning in sports analytics, offering tools that can lead to more informed and effective decision-making processes within the sports industry.


