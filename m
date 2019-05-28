From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH 3/7] vfs: Add a mount-notification facility
Date: Wed, 29 May 2019 01:23:36 +0200
Message-ID: <CAG48ez2SAKbPeChAf06GMazMPPThFM+OR00abRZafAP7v+ptKw@mail.gmail.com>
References: <155905930702.7587.7100265859075976147.stgit@warthog.procyon.org.uk>
 <155905933492.7587.6968545866041839538.stgit@warthog.procyon.org.uk>
 <CAG48ez2rRh2_Kq_EGJs5k-ZBNffGs_Q=vkQdinorBgo58tbGpg@mail.gmail.com> <10418.1559084686@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <10418.1559084686@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, raven@themaw.net, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-block@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module <linux-security-module@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, May 29, 2019 at 1:04 AM David Howells <dhowells@redhat.com> wrote:
> Jann Horn <jannh@google.com> wrote:
> > It might make sense to redesign this stuff so that watches don't hold
> > references on the object being watched.
>
> I explicitly made it hold a reference so that if you place a watch on an
> automounted mount it stops it from expiring.
>
> Further, if I create a watch on something, *should* it be unmountable, just as
> if I had a file open there or had chdir'd into there?

I don't really know. I guess it depends on how it's being used? If
someone decides to e.g. make a file browser that installs watches for
a bunch of mountpoints for some fancy sidebar showing the device
mounts on the system, or something like that, that probably shouldn't
inhibit unmounting... I don't know if that's a realistic use case.
