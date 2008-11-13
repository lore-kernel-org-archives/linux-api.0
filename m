From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 0/2] Shared flags
Date: Thu, 13 Nov 2008 04:25:54 -0500
Message-ID: <20081113092554.GA3004@infradead.org>
References: <49183DF9.9010003@etersoft.ru> <20081111085211.GB2323@infradead.org> <20081111100940.GA8968@shareable.org> <20081111111428.GA18228@infradead.org> <491BFCBA.80208@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <491BFCBA.80208-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, jamie-yetKDKU6eevNLxjTenLetw@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Nov 13, 2008 at 01:08:58PM +0300, Pavel Shilovsky wrote:
> We suggest to switch on this flags with special options during mounting.  
> By default, it'll be switch off.
> This solution deletes possibility of such situations, like in example.

Sorry, having completely weird open modes only for one filesystem, and
only depending on mount options is not very nice to the user.

And options or not allowing the above functionality for regular users
is a security issue.

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
