From: Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH V31 25/25] debugfs: Disable open() when kernel is locked down
Date: Tue, 26 Mar 2019 19:06:36 -0700
Message-ID: <CACdnJuvBJmCRnzT=4qh9cmNkRNHi3Xfha5xqUqYu8cgCRrtsqQ@mail.gmail.com>
References: <20190326182742.16950-1-matthewgarrett@google.com>
 <20190326182742.16950-26-matthewgarrett@google.com> <20190327003130.GB27311@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190327003130.GB27311@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: James Morris <jmorris@namei.org>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 26, 2019 at 5:31 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> On Tue, Mar 26, 2019 at 11:27:41AM -0700, Matthew Garrett wrote:
> > From: Matthew Garrett <mjg59@google.com>
> >
> > debugfs has not been meaningfully audited in terms of ensuring that
> > userland cannot trample over the kernel. At Greg's request, disable
> > access to it entirely when the kernel is locked down. This is done at
> > open() time rather than init time as the kernel lockdown status may be
> > made stricter at runtime.

(snip)

> Why allow all this, why not just abort the registering of the filesystem
> with the vfs core so it can't even be mounted?

As mentioned in the commit message, because the lockdown state can be
made stricter at runtime - blocking at mount time would be
inconsistent if the machine is locked down afterwards. We could
potentially assert that it's the admin's responsibility to ensure that
debugfs isn't mounted at the point of policy being made stricter?
