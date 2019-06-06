From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 09/10] usb: Add USB subsystem notifications [ver #3]
Date: Thu, 6 Jun 2019 10:24:18 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1906061020000.1641-100000@iolanthe.rowland.org>
References: <155981420247.17513.18371208824032389940.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <155981420247.17513.18371208824032389940.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, raven@themaw.net, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, 6 Jun 2019, David Howells wrote:

> Add a USB subsystem notification mechanism whereby notifications about
> hardware events such as device connection, disconnection, reset and I/O
> errors, can be reported to a monitoring process asynchronously.

USB I/O errors covers an awfully large and vague field.  Do we really
want to include them?  I'm doubtful.

Alan Stern
