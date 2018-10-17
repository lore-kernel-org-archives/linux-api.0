From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: statx(2) API and documentation
Date: Thu, 18 Oct 2018 01:15:13 +0300
Message-ID: <CAOQ4uxjqS3R_0O6gKVFEUJR7BvB+rpaHekjZm+fhMA+7on8AwQ@mail.gmail.com>
References: <CAJfpegsxFUGeczcC-pzK0WWROjv48_PvXtNun-f5QJMoUDn1Dw@mail.gmail.com>
 <006890C4-64D4-4DE2-A1F0-335FFFD585BB@dilger.ca> <CAJfpeguvJZbP83mSULc74Yhpp_CPMBW1XvcgbvCbLnF7QCncUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJfpeguvJZbP83mSULc74Yhpp_CPMBW1XvcgbvCbLnF7QCncUA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Andreas Dilger <adilger@dilger.ca>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, David Howells <dhowells@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Jan Kara <jack@suse.cz>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 17, 2018 at 10:12 PM Miklos Szeredi <miklos@szeredi.hu> wrote:

> >> - STATX_ALL definition is unclear, can this change, or is it fixed?
> >> If it's the former, than that's a backward compatibility nightmare.
> >> If it's the latter, then what's the point?
> >
> > The value can change over time.  It is intended to reflect the current
> > state of affairs at the time the userspace program and kernel are compiled.
> > The value sent from userspace lets the kernel know what fields are in
> > the userspace struct, so it doesn't try to set fields that aren't there.
>
> What's the point of a userspace program specifying STATX_ALL?  Without
> a way to programmatically query the interface definition it's useless:
> there's no way to guess which mask bit corresponds to which field, and
> what that field represents.
>
> And there will be programs out there which specify STATX_ALL without
> considering that in the future it may become slower as it is now due
> to a recompile.
>
> So what's the point exactly?
>
> > The value in the kernel allows masking off new fields from userspace that
> > it doesn't understand.
>
> Okay, but that has nothing to do with the UAPI.  Even as an internal
> flag we should be careful, as it might grow uses which can have
> similar issues as the userspace one above.
>

FYI, I identified a similar anti-pattern in fanotify UAPI when I wanted to
add new flags and did not want to change the UAPI _ALL_ constants.
This is how we plan to solve it:
https://github.com/amir73il/linux/commit/8c2b1acadb88ee4505ccc8bfdc665863111fb4cc

Thanks,
Amir.
