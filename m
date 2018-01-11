From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 03/32] fs: introduce new ->get_poll_head and
	->poll_mask methods
Date: Thu, 11 Jan 2018 12:32:56 +0100
Message-ID: <20180111113256.GA4078@lst.de>
References: <20180110155853.32348-1-hch@lst.de> <20180110155853.32348-4-hch@lst.de> <20180110210416.GH13338@ZenIV.linux.org.uk> <20180111052200.GJ13338@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180111052200.GJ13338@ZenIV.linux.org.uk>
Sender: owner-linux-aio@kvack.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

For other horrors that are even worse than any given ->poll instance
take a look at scif_poll and friends..

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
