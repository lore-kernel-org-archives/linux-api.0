From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] statx: reject unknown flags when using NULL path
Date: Fri, 31 Mar 2017 16:43:15 +0100
Message-ID: <20170331154315.GB29622@ZenIV.linux.org.uk>
References: <20170311065823.4415-1-ebiggers3@gmail.com>
 <20170320171142.GA26906@gmail.com>
 <20170320174422.GA9304@infradead.org>
 <20170331153952.GA32460@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170331153952.GA32460@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Biggers <ebiggers3@gmail.com>, linux-fsdevel@vger.kernel.org, David Howells <dhowells@redhat.com>, mtk.manpages@gmail.com, "Darrick J . Wong" <darrick.wong@oracle.com>, Linux API <linux-api@vger.kernel.org>, linux-xfs@vger.kernel.org, Eric Biggers <ebiggers@google.com>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 31, 2017 at 08:39:52AM -0700, Christoph Hellwig wrote:
> Al, Linus:
> 
> can we get this in please?  It would be sad to grow another syscall
> with an unchecked flags argument..

Applied, will be in tonight pull request...
