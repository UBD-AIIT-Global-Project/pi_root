#!/usr/bin/python
# -*-  coding: utf-8 -*-

import twitter
#import random

class TwitterSend:
	def __init__(self):
		self.msg=''

	def setMsg(self, index):
		self.msg=''
		self.msg='水位検知!!警告!!'

	def sendMsg(self):
		tweets = []
		tweets.append(self.msg)
		tweet = tweets[0]

		api = twitter.Api(consumer_key ="GYZOB5EeO1ul5o3538QpVxiyq",
			consumer_secret = "NcLEl8H5nQLtlunVEgwWEG9q9WZnsdPBew3xbjF8qAjF4GqYTa",
			access_token_key = "3932162593-drbVR0tvpwXBxtXQRJdkMpq9W7e0LG5JGQ3SDW4",
			access_token_secret = "9Yfxy9S7tePHdAGHUi8H6TjKAZxQcEJdKzxrfrtZszDdo")
		api.PostUpdate(tweet)
