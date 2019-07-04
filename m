From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 01/13] vfs: verify param type in vfs_parse_sb_flag()
Date: Thu, 04 Jul 2019 17:19:48 +0100
Message-ID: <11485.1562257188@warthog.procyon.org.uk>
References: <CAJfpegv_ezsXOLV2f7yd07=T3MenJoMKhu=MBac1-80s0BFg9A@mail.gmail.com> <20190619123019.30032-1-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJfpegv_ezsXOLV2f7yd07=T3MenJoMKhu=MBac1-80s0BFg9A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, Al Viro <viro@zeniv.linux.org.uk>, Miklos Szeredi <mszeredi@redhat.com>, Ian Kent <raven@themaw.net>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> wrote:

> Ping?  Have you had a chance of looking at this series?

Yeah, through due to time pressure, I haven't managed to do much with it.

I don't agree with all your changes, and also I'd like them to wait till after
the branch of mount API filesystem conversions that I've given to Al has had a
chance to hopefully go in in this merge window, along with whatever changes Al
has made to it.

Bocsánat,
David
