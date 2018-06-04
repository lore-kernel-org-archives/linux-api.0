From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH][RFC] open_tree(2) (was Re: [PATCH 30/32] vfs: Allow cloning of a mount tree with open(O_PATH|O_CLONE_MOUNT) [ver #8])
Date: Mon, 04 Jun 2018 16:27:01 +0100
Message-ID: <26844.1528126021@warthog.procyon.org.uk>
References: <CAELBmZCXMkCY+Lkz2xmhUiK_5oDctZzozHP-cXv9vp7qWsOtVQ@mail.gmail.com> <20180602040434.GW30522@ZenIV.linux.org.uk> <20180601063928.GS30522@ZenIV.linux.org.uk> <152720672288.9073.9868393448836301272.stgit@warthog.procyon.org.uk> <152720691829.9073.10564431140980997005.stgit@warthog.procyon.org.uk> <20180601062654.GA32397@infradead.org> <7067.1527841663@warthog.procyon.org.uk> <20180602030913.GU30522@ZenIV.linux.org.uk> <20180602034255.GV30522@ZenIV.linux.org.uk> <21804.1527954321@warthog.procyon.org.uk> <20180602174957.GX30522@ZenIV.linux.org.uk> <20180603005532.GZ30522@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAELBmZCXMkCY+Lkz2xmhUiK_5oDctZzozHP-cXv9vp7qWsOtVQ@mail.gmail.com>
Content-ID: <26843.1528126021.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-afs@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> wrote:

> fsinfo = info from path

Actually, I was thinking of making fsinfo() detect if it's been given an fsfd
and go through an fs_context operation instead in that case.

David
