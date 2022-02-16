#!/usr/bin/env python
# coding: utf-8

# In[11]:


# Import libraries

import pandas as pd
import numpy as np
import seaborn as sns

import matplotlib.pyplot as plt
import matplotlib.mlab as mlab
import matplotlib
plt.style.use('ggplot')
from matplotlib.pyplot import figure

get_ipython().run_line_magic('matplotlib', 'inline')
matplotlib.rcParams['figure.figsize'] = (12,8) #Adjusts the configuration of the plots we will create


# Read in the data

df = pd.read_csv(r'C:\Users\Sebastian Ramirez\OneDrive\Desktop\SQL projects\movies.csv')


# In[5]:


# lets look at the data

df.head()


# In[13]:


# Let's see if there is any missing data

for col in df.columns:
    pct_missing = np.mean(df[col].isnull())
    print('{} - {}%'.format(col,pct_missing))
    
# There is some missing data


# In[14]:


# Data types for our columns

df.dtypes


# In[ ]:





# In[18]:


df


# In[17]:


# Create correct year column
df['yearcorrect'] = df['released'].astype(str).str[:4]


# In[45]:


df.sort_values(by=['gross'], inplace=False, ascending=False)


# In[20]:


pd.set_option('display.max_rows', None)


# In[23]:


# Drop any duplicates

df.drop_duplicates()


# In[ ]:


# Budget high correlation
# Company high correlation


# In[25]:


# Scatter plot with budget vs gross

plt.scatter(x=df['budget'], y=df['gross'])

plt.title('Budget vs Gross Earnings')

plt.xlabel('Gross Earnings')

plt.ylabel('Budget for Film')

plt.show()


# In[27]:


df.head()


# In[29]:


# Plot budget vs gross using seaborn

sns.regplot(x='budget',y='gross', data=df, scatter_kws={"color":"red"}, line_kws={"color":"blue"})


# In[ ]:


# Looking at Correlation


# In[30]:


df.corr(method='pearson') # Different correlation methods: pearson, kendall, spearman


# In[ ]:


# High correlation between budget and gross


# In[32]:


correlation_matrix = df.corr(method='pearson')

sns.heatmap(correlation_matrix, annot=True)

plt.title('Correlation Matric for Numeric Features')

plt.xlabel('Movie Features')

plt.ylabel('Movie Features')

plt.show()


# In[33]:


# Looks at Company

df.head()


# In[46]:


df_numerized = df

for col_name in df_numerized.columns:
    if (df_numerized[col_name].dtype == 'object'):
        df_numerized[col_name] = df_numerized[col_name].astype('category')
        df_numerized[col_name] = df_numerized[col_name].cat.codes
        
df_numerized.head()


# In[39]:


correlation_matrix = df_numerized.corr(method='pearson')

sns.heatmap(correlation_matrix, annot=True)

plt.title('Correlation Matric for Numeric Features')

plt.xlabel('Movie Features')

plt.ylabel('Movie Features')

plt.show()


# In[40]:


df_numerized.corr()


# In[41]:


correlation_mat = df_numerized.corr()

corr_pairs = correlation_mat.unstack()

corr_pairs


# In[42]:


sorted_pairs = corr_pairs.sort_values()

sorted_pairs


# In[43]:


high_corr = sorted_pairs[(sorted_pairs) > 0.5]

high_corr


# In[ ]:


# Votes and budget have the higest correlation to gross earnings

# Company has low correlation

