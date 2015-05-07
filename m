From: Zach Brown <zab@redhat.com>
Subject: Re: [PATCH RFC] vfs: add a O_NOMTIME flag
Date: Thu, 7 May 2015 11:43:50 -0700
Message-ID: <20150507184350.GA1945@lenny.home.zabbo.net>
References: <1430949612-21356-1-git-send-email-zab@redhat.com>
 <20150507002617.GJ4327@dastard>
 <20150507172053.GA659@lenny.home.zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150507172053.GA659@lenny.home.zabbo.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Sage Weil <sweil@redhat.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

> > > The criteria for using O_NOMTIME is the same as for using O_NOATIME:
> > > owning the file or having the CAP_FOWNER capability.  If we're not
> > > comfortable allowing owners to prevent mtime/ctime updates then we
> > > should add a tunable to allow O_NOMTIME.  Maybe a mount option?
> > 
> > I dislike "turn off safety for performance" options because Joe
> > SpeedRacer will always select performance over safety.
> 
> Well, for ceph there's no safety concern.  They never use cmtime in
> these files.
> 
> So are you suggesting not implementing this and making them rework their
> IO paths to avoid the fs maintaining mtime so that we don't give Joe
> Speedracer more rope?  Or are we talking about adding some speed bumps
> that ceph can flip on that might give Joe Speedracer pause?

Maybe one way to make it less of an attractive nuisance would be to hide
it under open_by_handle_at().  Like xfs_open_by_handle() does today but
we probably don't want to unconditionally add it to the generic path so
we'd have a flag.

They want to move to opening by handles anyway to avoid dirent lookups
when opening cold files.

- z
