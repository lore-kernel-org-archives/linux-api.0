From: Jan Kara <jack@suse.cz>
Subject: Re: statx(2) API and documentation
Date: Thu, 18 Oct 2018 09:41:01 +0200
Message-ID: <20181018074101.GJ23493@quack2.suse.cz>
References: <CAJfpegsxFUGeczcC-pzK0WWROjv48_PvXtNun-f5QJMoUDn1Dw@mail.gmail.com>
 <006890C4-64D4-4DE2-A1F0-335FFFD585BB@dilger.ca>
 <CAJfpeguvJZbP83mSULc74Yhpp_CPMBW1XvcgbvCbLnF7QCncUA@mail.gmail.com>
 <CAOQ4uxjqS3R_0O6gKVFEUJR7BvB+rpaHekjZm+fhMA+7on8AwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjqS3R_0O6gKVFEUJR7BvB+rpaHekjZm+fhMA+7on8AwQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Andreas Dilger <adilger@dilger.ca>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, David Howells <dhowells@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Jan Kara <jack@suse.cz>
List-Id: linux-api@vger.kernel.org

On Thu 18-10-18 01:15:13, Amir Goldstein wrote:
> On Wed, Oct 17, 2018 at 10:12 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> 
> > >> - STATX_ALL definition is unclear, can this change, or is it fixed?
> > >> If it's the former, than that's a backward compatibility nightmare.
> > >> If it's the latter, then what's the point?
> > >
> > > The value can change over time.  It is intended to reflect the current
> > > state of affairs at the time the userspace program and kernel are compiled.
> > > The value sent from userspace lets the kernel know what fields are in
> > > the userspace struct, so it doesn't try to set fields that aren't there.
> >
> > What's the point of a userspace program specifying STATX_ALL?  Without
> > a way to programmatically query the interface definition it's useless:
> > there's no way to guess which mask bit corresponds to which field, and
> > what that field represents.
> >
> > And there will be programs out there which specify STATX_ALL without
> > considering that in the future it may become slower as it is now due
> > to a recompile.
> >
> > So what's the point exactly?
> >
> > > The value in the kernel allows masking off new fields from userspace that
> > > it doesn't understand.
> >
> > Okay, but that has nothing to do with the UAPI.  Even as an internal
> > flag we should be careful, as it might grow uses which can have
> > similar issues as the userspace one above.
> >
> 
> FYI, I identified a similar anti-pattern in fanotify UAPI when I wanted to
> add new flags and did not want to change the UAPI _ALL_ constants.
> This is how we plan to solve it:
> https://github.com/amir73il/linux/commit/8c2b1acadb88ee4505ccc8bfdc665863111fb4cc

Yeah, after fanotify experience I find foo_ALL constants useless if not
dangerous for userspace.  Kernel internal constants like this are IMO
useful.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
