From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH 0/2] Shared flags
Date: Fri, 14 Nov 2008 03:37:12 +0000
Message-ID: <20081114033712.GL2055@shareable.org>
References: <49183DF9.9010003@etersoft.ru> <20081111085211.GB2323@infradead.org> <20081111100940.GA8968@shareable.org> <20081111111428.GA18228@infradead.org> <491BFCBA.80208@etersoft.ru> <20081113092554.GA3004@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20081113092554.GA3004@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Pavel Shilovsky <piastry@etersoft.ru>, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Christoph Hellwig wrote:
> On Thu, Nov 13, 2008 at 01:08:58PM +0300, Pavel Shilovsky wrote:
> > We suggest to switch on this flags with special options during mounting.  
> > By default, it'll be switch off.
> > This solution deletes possibility of such situations, like in example.
> 
> Sorry, having completely weird open modes only for one filesystem, and
> only depending on mount options is not very nice to the user.
> 
> And options or not allowing the above functionality for regular users
> is a security issue.

A generic mount option is currently used for mandatory locking - this
is very similar.

The only different I see, for security, is with mandatory locking a
process which doesn't want to get stuck can check the permission bits
before opening a file.  But I'm not aware of anything actually doing this.

-- Jamie
