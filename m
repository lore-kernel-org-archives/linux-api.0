From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 24/32] vfs: syscall: Add fsopen() to prepare for
 superblock creation [ver #9]
Date: Thu, 12 Jul 2018 19:34:26 +0100
Message-ID: <20180712183426.GC30522@ZenIV.linux.org.uk>
References: <153126248868.14533.9751473662727327569.stgit@warthog.procyon.org.uk>
 <153126264966.14533.3388004240803696769.stgit@warthog.procyon.org.uk>
 <20180712171505.GA23780@kroah.com>
 <20180712172024.GZ30522@ZenIV.linux.org.uk>
 <20180712180304.GA27758@kroah.com>
 <76211EBC-05ED-4FBA-A136-F5EEBFDD9FDF@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <76211EBC-05ED-4FBA-A136-F5EEBFDD9FDF@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Greg KH <gregkh@linuxfoundation.org>, David Howells <dhowells@redhat.com>, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Jul 12, 2018 at 11:30:32AM -0700, Andy Lutomirski wrote:

Andi, Greg - alt.tasteless is over -> that way.

And for fsck sake, fix your MUA.  Lines are obscenely long...

> How do you mount configfs in the first place?  And how do you use this in a mount namespace without a private configfs instance or where you don’t want configfs mounted?
