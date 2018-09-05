From: David Howells <dhowells@redhat.com>
Subject: Re: [RFC] UAPI: Check headers by compiling all together as C++
Date: Wed, 05 Sep 2018 18:50:42 +0100
Message-ID: <22225.1536169842@warthog.procyon.org.uk>
References: <20180905165552.GB25206@kroah.com> <153616286704.23468.584491117180383924.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180905165552.GB25206@kroah.com>
Content-ID: <22224.1536169842.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: dhowells@redhat.com, linux-api@vger.kernel.org, linux-kbuild@vger.kernel.org, dri-devel@lists.freedesktop.org, virtualization@lists.linux-foundation.org, keyrings@vger.kernel.org, netfilter-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org, alsa-devel@alsa-project.org, freedreno@lists.freedesktop.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Greg KH <greg@kroah.com> wrote:

> > Here's a set of patches that inserts a step into the build process to make
> > sure that the UAPI headers can all be built together with C++ (if the
> > compiler being used supports C++).  All but the final patch perform fixups,
> > including:
> 
> Wait, why do we care?  What has recently changed to start to directly
> import kernel uapi files into C++ code?

There's at least one outstanding bug due to a C++ identifier in the kernel
UAPI headers.

Are you saying you explicitly don't want people to be able to use the kernel
UAPI headers in C++?

> And if userspace wants to do this, can't they do the C namespace trick
> themselves when they do the import?  That must be how they are doing it
> today, right?

No, because there's no such trick (except with the preprocessor).

David
