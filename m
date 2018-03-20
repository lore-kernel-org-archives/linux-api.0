From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 08/36] aio: implement io_pgetevents
Date: Tue, 20 Mar 2018 11:34:22 -0400
Message-ID: <x49efkepxq9.fsf@segfault.boston.devel.redhat.com>
References: <20180305212743.16664-1-hch@lst.de>
	<20180305212743.16664-9-hch@lst.de> <20180320021241.GE7282@magnolia>
	<20180320152220.GC23920@lst.de>
	<x49muz2pxwq.fsf@segfault.boston.devel.redhat.com>
	<20180320153145.GA24313@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180320153145.GA24313@lst.de> (Christoph Hellwig's message of
	"Tue, 20 Mar 2018 16:31:45 +0100")
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Christoph Hellwig <hch@lst.de> writes:

> On Tue, Mar 20, 2018 at 11:30:29AM -0400, Jeff Moyer wrote:
>> > In this commit:
>> >
>> > http://git.infradead.org/users/hch/libaio.git/commitdiff/49f77d595210393ce7b125cb00233cf737402f56
>> 
>> BTW, the man pages are shipped in the man-pages package, now.
>> Christoph, I can forward the change to Michael after this series goes
>> in.  Just let me know what's easiest for you.
>
> I'd be more than happy to send patch to Michael if we get these
> patches merged finally :)

hahaha, least of your problems, I know.  :)

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
