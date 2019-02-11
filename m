From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 13/18] io_uring: add file set registration
Date: Mon, 11 Feb 2019 08:55:33 -0700
Message-ID: <20190211085533.35190404@lwn.net>
References: <20190129192702.3605-1-axboe@kernel.dk>
	<20190129192702.3605-14-axboe@kernel.dk>
	<CAG48ez2kLWUEambWesQQaeVn_u=PtjuMeDUc49yamhYspfd7Sg@mail.gmail.com>
	<20190204025612.GR2217@ZenIV.linux.org.uk>
	<785c6db4-095e-65b0-ded5-72b41af5174e@kernel.dk>
	<2b2137ed-8107-f7b6-f0ca-202dcfb87c97@kernel.dk>
	<40b27e78-9ee8-1395-feb3-a73aac87c9a7@kernel.dk>
	<20190206005638.GU2217@ZenIV.linux.org.uk>
	<8f124de2-d6da-d656-25e4-b4d9e58f880e@kernel.dk>
	<20190207040058.GW2217@ZenIV.linux.org.uk>
	<73e23146-2138-5a46-46ed-9c7f1f912a04@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <73e23146-2138-5a46-46ed-9c7f1f912a04@kernel.dk>
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jann Horn <jannh@google.com>, linux-aio@kvack.org, linux-block@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, linux-fsdevel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, 7 Feb 2019 11:45:40 -0700
Jens Axboe <axboe@kernel.dk> wrote:

> > OK, braindump time:  
> 
> [snip]
> 
> This is great info, and I think it belongs in Documentation/ somewhere.
> Not sure I've ever seen such a good and detailed dump of this before.

I suspect I might be able to make something like that happen :)  Stay
tuned.

Thanks,

jon

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
