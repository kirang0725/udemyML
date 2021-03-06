# Reading in Data
ds = read.csv('Social_Network_Ads.csv')
ds = ds[, 3:5]

# Scaling and splitting
library(caTools)
ds[,1:2] = scale(ds[,1:2])

split = sample.split(ds$Purchased, SplitRatio = 0.75)
train = subset(ds, split == TRUE)
test = subset(ds, split == FALSE)

# Classifier
library(class)
y_pred = knn(train[, -3], 
             test[, -3], 
             cl = train[, 3], 
             k = 5)

# Confusion matrix
cm = table(test[, 3], y_pred)

# Plot
library('ElemStatLearn')
set = train
X1 = seq(min(set[, 1]) - 1, max(set[, 1]) + 1, by = 0.01)
X2 = seq(min(set[, 2]) - 1, max(set[, 2]) + 1, by = 0.01)
grid_set = expand.grid(X1, X2)
colnames(grid_set) = c('Age', 'EstimatedSalary')
y_grid = knn(train[, -3], 
             grid_set, 
             cl = train[, 3], 
             k = 5)
plot(set[, -3],
     main = 'K-NN (Training set)',
     xlab = 'Age', ylab = 'Estimated Salary',
     xlim = range(X1), ylim = range(X2))
contour(X1, X2, matrix(as.numeric(y_grid), length(X1), length(X2)), add = TRUE)
points(grid_set, pch = '.', col = ifelse(y_grid == 1, 'springgreen3', 'tomato'))
points(set, pch = 21, bg = ifelse(set[, 3] == 1, 'green4', 'red3'))