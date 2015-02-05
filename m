From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [v8 4/5] ext4: adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR
 interface support
Date: Thu, 5 Feb 2015 17:38:15 +0100
Message-ID: <20150205163815.GK4258@quack.suse.cz>
References: <54C11733.7080801@yandex-team.ru>
 <20150123015307.GD24722@dastard>
 <54C23751.7000009@yandex-team.ru>
 <20150123233026.GP16552@dastard>
 <CALCETrXPCrOTrkoAMuW2os=z6anaEfv4F4D2yDxo6VtCuEtRZw@mail.gmail.com>
 <20150127080239.GQ16552@dastard>
 <54C76C3D.4070404@yandex-team.ru>
 <20150128003746.GR16552@dastard>
 <54D23919.3000408@yandex-team.ru>
 <20150204225844.GA12722@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150204225844.GA12722@dastard>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

  Hello,

> Users have *always* been allowed to set the project ID of
> their own files. How else are they going to set the project ID on
> files they create in random directories so to account them to the
> correct project they are working on?
> 
> However, you keep making the assumption that project quotas ==
> directory subtree quotas.  Project quotas are *not limited* to
> directory subtrees - the subtree quota implementation is just an
> implementation that *sets the default project ID* on files as they
> are created.
> 
> e.g. there are production systems out there where project quotas are
> used to track home directory space usage rather than user quotas.
> This means users can take actions like "this file actually belongs
> to project X and it shouldn't be accounted against my home
> directory". Users can create their own sub directories that account
> everything by default to project X rather than their own home
> directory.
> 
> Again: project quotas are an *accounting* mechanism, not a security
> mechanism.
  OK, but now I got confused ;) So if users can change project ID of files
they own, what's the point of project quotas? If I need to create a file
and project quota doesn't allow me, I just set its project ID to some
random number and I'm done with that... So are really project quotas just
"advisory" - i.e., all users of a system cooperate so that project X
doesn't use more space than it should (and project quotas make this
cooperation somewhat simpler) or is there something which limits which
project IDs user can set? I didn't find anything...

								Honza
-- 
Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
SUSE Labs, CR
