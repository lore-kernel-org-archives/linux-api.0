From: David Howells <dhowells@redhat.com>
Subject: Re: [GIT PULL] pipe: Notification queue preparation
Date: Thu, 05 Dec 2019 13:56:57 +0000
Message-ID: <1593.1575554217@warthog.procyon.org.uk>
References: <20191205125826.GK2734@twin.jikos.cz> <31452.1574721589@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191205125826.GK2734@twin.jikos.cz>
Content-ID: <1592.1575554217.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: dsterba@suse.cz
Cc: dhowells@redhat.com, torvalds@linux-foundation.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

David Sterba <dsterba@suse.cz> wrote:

> [<0>] pipe_write+0x1be/0x4b0

Can you get me a line number of that?  Assuming you've built with -g, load
vmlinux into gdb and do "i li pipe_write+0x1be".

David
