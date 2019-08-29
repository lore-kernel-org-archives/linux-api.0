From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 10/11] selinux: Implement the watch_key security hook [ver #6]
Date: Thu, 29 Aug 2019 20:11:57 +0100
Message-ID: <14149.1567105917@warthog.procyon.org.uk>
References: <03eb0974-3996-f356-5fbe-17cf598b0e31@tycho.nsa.gov> <156710338860.10009.12524626894838499011.stgit@warthog.procyon.org.uk> <156710348066.10009.17986469867635955040.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <03eb0974-3996-f356-5fbe-17cf598b0e31@tycho.nsa.gov>
Content-ID: <14148.1567105917.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, Casey Schaufler <casey@schaufler-ca.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Stephen Smalley <sds@tycho.nsa.gov> wrote:

> Can watch->cred ever differ from current's cred here?  If not, why can't we
> just use current_sid() here

Um.  Not currently.  I'm not sure whether its ever likely to be otherwise.
Probably we could just use that and fix it up later if we do find otherwise.

> and why do we need the watch object at all?

It carries more than just the creds for the caller of keyctl_watch_key(), it
also carries information about the queue to which notifications will be
written, including the creds that were active when that was set up.

Note that there's no requirement that the process that opened /dev/watch_queue
be the one that sets the watch.  In the keyutils testsuite, I 'leak' a file
descriptor from the session wrangler into the program that it runs so that
tests running inside the test script can add watches to it.

David
