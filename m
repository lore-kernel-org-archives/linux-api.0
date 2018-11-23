From: =?ISO-8859-1?Q?J=FCrg?= Billeter <j@bitron.ch>
Subject: Re: [PATCH v4 2/4] namei: O_BENEATH-style path resolution flags
Date: Fri, 23 Nov 2018 13:10:17 +0100
Message-ID: <1ce83cdf6e3168350b69f98f08aaa202bbaa682d.camel@bitron.ch>
References: <20181112142654.341-1-cyphar@cyphar.com>
         <20181112142654.341-3-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181112142654.341-3-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>, Christian Brauner <christian@brauner.io>, linux-api@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, Jann Horn <jannh@google.com>, David Drysdale <drysdale@google.com>, Aleksa Sarai <asarai@suse.de>, containers@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi Aleksa,

On Tue, 2018-11-13 at 01:26 +1100, Aleksa Sarai wrote:
> * O_BENEATH: Disallow "escapes" from the starting point of the
>   filesystem tree during resolution (you must stay "beneath" the
>   starting point at all times). Currently this is done by disallowing
>   ".." and absolute paths (either in the given path or found during
>   symlink resolution) entirely, as well as all "magic link" jumping.

With open_tree(2) and OPEN_TREE_CLONE, will O_BENEATH still be
necessary? As I understand it, O_BENEATH could be replaced by a much
simpler flag that only disallows absolute paths (incl. absolute
symlinks). And it would have the benefit that you can actually pass the
tree/directory fd to another process and escaping would not be possible
even if that other process doesn't use O_BENEATH (after calling
mount_setattr(2) to make sure it's locked down).

This approach would also make it easy to restrict writes via a cloned
tree/directory fd by marking it read-only via mount_setattr(2) (and
locking down the read-only flag). This would again be especially useful
when passing tree/directory fds across processes, or for voluntary
self-lockdown within a process for robustness against security bugs.

This wouldn't affect any of the other flags in this patch. And for full
equivalence to O_BENEATH you'd have to use O_NOMAGICLINKS in addition
to O_NOABSOLUTE, or whatever that new flag would be called.

Or is OPEN_TREE_CLONE too expensive for this use case? Or is there
anything else I'm missing?

Jürg
