From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 13/18] io_uring: add file set registration
Date: Mon, 11 Feb 2019 13:33:35 -0700
Message-ID: <20190211133335.2b114df8@lwn.net>
References: <CAG48ez2kLWUEambWesQQaeVn_u=PtjuMeDUc49yamhYspfd7Sg@mail.gmail.com>
	<20190204025612.GR2217@ZenIV.linux.org.uk>
	<785c6db4-095e-65b0-ded5-72b41af5174e@kernel.dk>
	<2b2137ed-8107-f7b6-f0ca-202dcfb87c97@kernel.dk>
	<40b27e78-9ee8-1395-feb3-a73aac87c9a7@kernel.dk>
	<20190206005638.GU2217@ZenIV.linux.org.uk>
	<8f124de2-d6da-d656-25e4-b4d9e58f880e@kernel.dk>
	<20190207040058.GW2217@ZenIV.linux.org.uk>
	<73e23146-2138-5a46-46ed-9c7f1f912a04@kernel.dk>
	<20190211085533.35190404@lwn.net>
	<20190211173521.GI2217@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190211173521.GI2217@ZenIV.linux.org.uk>
Sender: owner-linux-aio@kvack.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>, Jann Horn <jannh@google.com>, linux-aio@kvack.org, linux-block@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, linux-fsdevel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, 11 Feb 2019 17:35:21 +0000
Al Viro <viro@zeniv.linux.org.uk> wrote:

> If you turn that thing into a coherent text, I'd appreciate a chance
> to take a look at the result and see if anything else needs to be
> corrected...

Thanks for the updated info!

I'm likely to do a watered-down version for some disreputable web site
first; after that, I'll try to do it properly for Documentation/.  You'll
certainly see the result in your inbox once it's ready to be looked at.

Thanks,

jon

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
