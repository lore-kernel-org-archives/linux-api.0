From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] statx: reject unknown flags when using NULL path
Date: Fri, 31 Mar 2017 08:39:52 -0700
Message-ID: <20170331153952.GA32460@infradead.org>
References: <20170311065823.4415-1-ebiggers3@gmail.com>
 <20170320171142.GA26906@gmail.com>
 <20170320174422.GA9304@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170320174422.GA9304@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>, mtk.manpages@gmail.com, Christoph Hellwig <hch@infradead.org>, "Darrick J . Wong" <darrick.wong@oracle.com>, Linux API <linux-api@vger.kernel.org>, linux-xfs@vger.kernel.org, Eric Biggers <ebiggers@google.com>
List-Id: linux-api@vger.kernel.org

Al, Linus:

can we get this in please?  It would be sad to grow another syscall
with an unchecked flags argument..
