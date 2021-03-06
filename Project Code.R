# import data #

# install.packages("httr")
library(httr)

data.full <-read.csv(text=GET("https://raw.githubusercontent.com/TerrySitu/Multivariate-Analysis-of-Egyptian-Skulls/master/skulls.csv"), header=T)

data.full <- data.full[,-1]

data <- data.full[,2:5]
# data stat summary #
x_bar<- apply(data, 2, mean)
x_bar


cov.mat <- var(data)
cov.mat

corr.mat <- cor(data)
corr.mat

skulls1 <- as.matrix(subset(data.full, data.full[,1]=="c4000BC")[,2:5])
skulls2 <- as.matrix(subset(data.full, data.full[,1]=="c3300BC")[,2:5])
skulls3 <- as.matrix(subset(data.full, data.full[,1]=="c1850BC")[,2:5])
skulls4 <- as.matrix(subset(data.full, data.full[,1]=="c200BC")[,2:5])
skulls5 <- as.matrix(subset(data.full, data.full[,1]=="cAD150")[,2:5])

# group mean #
x_bar_1 <- apply(skulls1, 2, mean)
x_bar_2 <- apply(skulls2, 2, mean)
x_bar_3 <- apply(skulls3, 2, mean)
x_bar_4 <- apply(skulls4, 2, mean)
x_bar_5 <- apply(skulls5, 2, mean)

cbind(x_bar_1, x_bar_2, x_bar_3, x_bar_4)

# group variances #
s1 <- var(skulls1)
s2 <- var(skulls2)
s3 <- var(skulls3)
s4 <- var(skulls4)
s5 <- var(skulls5)


# group correlations #
corr1 <- cor(skulls1)
corr2 <- cor(skulls2)
corr3 <- cor(skulls3)
corr4 <- cor(skulls4)
corr5 <- cor(skulls5)


# test if it is reasonable to assume they have the same variances 
# sample size #
n1 = n2 = n3 = n4 = n5 <- nrow(skulls1)


p <- ncol(data)
g <- nlevels(data.full[,1])

# compute the u #
u <- (1/(n1-1)+1/(n2-1)+1/(n3-1)+1/(n4-1)+1/(n5-1)-1/(n1+n2+n3+n4+n5-g)) * (2*p^2+3*p-1)/ (6*(p+1)*(g-1))
u 

# compute S_pooled #

S_pooled <-((nrow(skulls1)-1)/(nrow(data.full)-g))*(s1+s2+s3+s4+s5)

# compute the M #
M <- (n1+n2+n3+n4+n5-g)*log(det(S_pooled))-((n1-1)*log(det(s1))+(n2-1)*log(det(s2))+(n3-1)*log(det(s3))+(n4-1)*log(det(s4))+(n5-1)*log(det(s5)))

# compute the C #
C <- (1-u)*M

# conclude the test of equality of variances #
ifelse(C>qchisq(.95, v), "Reject null hypothesis", "Fail to reject null hypothesis")

# compute W #
W <- (n1-1)*(s1+s2+s3+s4+s5)

# compute B #
B <- n1*(x_bar_1-x_bar)%*%t(x_bar_1-x_bar)+n2*(x_bar_2-x_bar)%*%t(x_bar_2-x_bar)+n3*(x_bar_3-x_bar)%*%t(x_bar_3-x_bar)+n4*(x_bar_4-x_bar)%*%t(x_bar_4-x_bar)+n5*(x_bar_5-x_bar)%*%t(x_bar_5-x_bar)

# compute T #
T <- B+W

# Construct 95% simultaneous confidence intervals for differences in the mean components for the two response variables for each pair of populations. #

t <- qt((1-(.05/(p*g*(g-1)))), nrow(data.full)-g)


F <- ((p*(nrow(data.full)-1))/(nrow(data.full)-p)*qf(1-.05, p, nrow(data.full)-p))
sqrt_F <- sqrt(F)



# compute differece in mean vectors among different groups #
tau_hat_1 <- x_bar_1-x_bar
tau_hat_2 <- x_bar_2-x_bar
tau_hat_3 <- x_bar_3-x_bar
tau_hat_4 <- x_bar_4-x_bar
tau_hat_5 <- x_bar_5-x_bar


# the difference in the mean between each pair of population #

d_t1_t2 <- tau_hat_1-tau_hat_2
d_t1_t3 <- tau_hat_1-tau_hat_3
d_t1_t4 <- tau_hat_1-tau_hat_4
d_t1_t5 <- tau_hat_1-tau_hat_5
d_t2_t3 <- tau_hat_2-tau_hat_3
d_t2_t4 <- tau_hat_2-tau_hat_4
d_t2_t5 <- tau_hat_2-tau_hat_5
d_t3_t4 <- tau_hat_3-tau_hat_4
d_t3_t5 <- tau_hat_3-tau_hat_5
d_t4_t5 <- tau_hat_4-tau_hat_5



# 95% simultaneous confidence intervals for treatment effects #
upper <- d_t1_t2 + t*sqrt((1/n1+1/n2)*(1/(nrow(data.full)-g))*diag(W))
lower <- d_t1_t2 - t*sqrt((1/n1+1/n2)*(1/(nrow(data.full)-g))*diag(W))

table_diff_t1_t2 <- cbind(lower, upper)

upper.F <- d_t1_t2 + sqrt_F*sqrt((1/n1+1/n2)*(1/(nrow(data.full)-g))*diag(W))
lower.F <- d_t1_t2 - sqrt_F*sqrt((1/n1+1/n2)*(1/(nrow(data.full)-g))*diag(W))

table_diff_t1_t2_F <- cbind(lower.F, upper.F)

upper <- d_t1_t3 + t*sqrt((1/n1+1/n3)*(1/(nrow(data.full)-g))*diag(W))
lower <- d_t1_t3 - t*sqrt((1/n1+1/n3)*(1/(nrow(data.full)-g))*diag(W))

table_diff_t1_t3 <- cbind(lower, upper)

upper.F <- d_t1_t3 + sqrt_F*sqrt((1/n1+1/n3)*(1/(nrow(data.full)-g))*diag(W))
lower.F <- d_t1_t3 - sqrt_F*sqrt((1/n1+1/n3)*(1/(nrow(data.full)-g))*diag(W))

table_diff_t1_t3_F <- cbind(lower.F, upper.F)

upper <- d_t1_t4 + t*sqrt((1/n1+1/n3)*(1/(nrow(data.full)-g))*diag(W))
lower <- d_t1_t4 - t*sqrt((1/n1+1/n3)*(1/(nrow(data.full)-g))*diag(W))

table_diff_t1_t4 <- cbind(lower, upper)


upper <- d_t1_t5 + t*sqrt((1/n1+1/n3)*(1/(nrow(data.full)-g))*diag(W))
lower <- d_t1_t5 - t*sqrt((1/n1+1/n3)*(1/(nrow(data.full)-g))*diag(W))

table_diff_t1_t5 <- cbind(lower, upper)

upper <- d_t2_t3 + t*sqrt((1/n2+1/n3)*(1/(nrow(data.full)-g))*diag(W))
lower <- d_t2_t3 - t*sqrt((1/n2+1/n3)*(1/(nrow(data.full)-g))*diag(W))

table_diff_t2_t3 <- cbind(lower, upper)


upper <- d_t2_t4 + t*sqrt((1/n2+1/n3)*(1/(nrow(data.full)-g))*diag(W))
lower <- d_t2_t4 - t*sqrt((1/n2+1/n3)*(1/(nrow(data.full)-g))*diag(W))

table_diff_t2_t4 <- cbind(lower, upper)

upper <- d_t2_t5 + t*sqrt((1/n2+1/n3)*(1/(nrow(data.full)-g))*diag(W))
lower <- d_t2_t5 - t*sqrt((1/n2+1/n3)*(1/(nrow(data.full)-g))*diag(W))

table_diff_t2_t5 <- cbind(lower, upper)


upper <- d_t3_t4 + t*sqrt((1/n2+1/n3)*(1/(nrow(data.full)-g))*diag(W))
lower <- d_t3_t4 - t*sqrt((1/n2+1/n3)*(1/(nrow(data.full)-g))*diag(W))

table_diff_t3_t4 <- cbind(lower, upper)

upper <- d_t3_t5 + t*sqrt((1/n2+1/n3)*(1/(nrow(data.full)-g))*diag(W))
lower <- d_t3_t5 - t*sqrt((1/n2+1/n3)*(1/(nrow(data.full)-g))*diag(W))

table_diff_t3_t5 <- cbind(lower, upper)


upper <- d_t4_t5 + t*sqrt((1/n2+1/n3)*(1/(nrow(data.full)-g))*diag(W))
lower <- d_t4_t5 - t*sqrt((1/n2+1/n3)*(1/(nrow(data.full)-g))*diag(W))

table_diff_t4_t5 <- cbind(lower, upper)

# scatterplots #
# option 1 #
library(lattice)
splom(data.full[,2:5], groups=data.full[,1],pch=c(1,2,3,4,5), col=c(1,2,3,4,5), key=list(title="Three Time Periods",columns=5,points=list(pch=c(1,2,3,4,5),col=c(1,2,3,4,5)),text=list(c("4000 B.C.","3300 B.C.","1850 B.C.", "200 B.C", "150 A.D"))))

# option 2 #
library(car)
scatterplotMatrix(~mb+bh+bl+nh|epoch, data=data.full, col=c(1,2,3,4,5), pch=c(1,2,3,4,5),main="Three Time Period")

# assessment of normality #
library(nortest)
nor.test <- matrix(ncol=1,nrow=ncol(data))
for ( i in 1:ncol(data)){
  nor.test[i] <- ad.test(data[,i])$p.value
}
nor.test

# Normality test for multivariate variables #
library(mvnormtest)
mshapiro.test(t(data))

# MANOVA #
library(car)
fit.lm <- lm(cbind(mb, bh, bl, nh)~epoch , data = data.full)
fit.manova <- Manova(fit.lm)
summary(fit.manova)

# Multivariate Outlier Detection #
out <- mvOutlier(data, qqplot = TRUE, alpha = 0.5, method = c("quan", "adj.quan"))

# construct chi square plot #
# Find all statistical distances  
data.m <- as.matrix(data)
d = NULL
for (i in 1:nrow(data)){
  d<-cbind(d, t(data.m[i,] - apply(data.m, 2, mean))%*%solve(var(data.m))%*%(data.m[i,]-apply(data,2,mean)))
}


a <- matrix(, nrow=nrow(data), ncol=1)
for (k in 1:nrow(data.full)){
  a[k,] <- d[k]
  a <- as.data.frame(a)
  colnames(a) <- "Statistical Distance"
}

#  Compute quantiles of a chi-square distribution  

q1 <- NULL
for (i in 1:nrow(data.m)){
  q1 <- cbind(q1, qchisq((i-0.5) / (nrow(data.m)), ncol(data.m))) }


#  Order the squared distances from smallest to largest

d <- sort(d) 

#  Specify a (5 inch)x(5 inch) plot

par(mfrow = c(1,1), fin = c(5,5))

#  Create the chi-squared probability plot

d <- matrix(d, nrow = nrow(data.m), ncol = 1)
q1 <- matrix(q1, nrow = nrow(data.m), ncol = 1)

plot(q1, d, type="p", pch=1, xlab="Chi-square quantiles",ylab="Ordered distances", main="Chi-Square Probability Plot") 
lines(q1, q1, lty=1)

##Perform PCA to see if we can reduce the number of dimensions
skulls.pc <- prcomp(data)




