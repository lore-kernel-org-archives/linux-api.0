From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH RFC] vfs: add a O_NOMTIME flag
Date: Mon, 11 May 2015 10:47:19 -0400
Message-ID: <20150511144719.GA14088@thunk.org>
References: <1430949612-21356-1-git-send-email-zab@redhat.com>
 <20150507002617.GJ4327@dastard>
 <20150507172053.GA659@lenny.home.zabbo.net>
 <alpine.DEB.2.00.1505071752520.28239@cobra.newdream.net>
 <CAHQdGtQjMHA8rVPkggB2zMz=k3O667+APH_1EY_2FtYmHL7-hw@mail.gmail.com>
 <20150508221325.GM4327@dastard>
 <alpine.DEB.2.00.1505081517470.28239@cobra.newdream.net>
 <CAHQdGtTFTN2XuvmarFZ9HPQV=cuhh7FosdHSrJME_U4htr=i8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHQdGtTFTN2XuvmarFZ9HPQV=cuhh7FosdHSrJME_U4htr=i8w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Trond Myklebust <trond.myklebust@primarydata.com>
Cc: Sage Weil <sage@newdream.net>, Dave Chinner <david@fromorbit.com>, Zach Brown <zab@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API Mailing List <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Sun, May 10, 2015 at 07:13:24PM -0400, Trond Myklebust wrote:
> That makes it completely non-generic though. By putting this in the
> VFS, you are giving applications a loaded gun that is pointed straight
> at the application user's head.

Let me re-ask the question that I asked last week (and was apparently
ignored).  Why not trying to use the lazytime feature instead of
pointing a head straight at the application's --- and system
administrators' --- heads?

						- Ted
