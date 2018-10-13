From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v3 3/3] namei: aggressively check for nd->root escape on
 ".." resolution
Date: Sat, 13 Oct 2018 10:04:32 +0100
Message-ID: <20181013090432.GV32577@ZenIV.linux.org.uk>
References: <20181009070230.12884-1-cyphar@cyphar.com>
 <20181009070230.12884-4-cyphar@cyphar.com>
 <CAG48ez3Ae5b20g2UquekfBNaUw1tLt4nWy2pYm-LNRMbDVpHfA@mail.gmail.com>
 <20181009153728.2altaqxclntvyc7b@mikami>
 <20181013082210.GU32577@ZenIV.linux.org.uk>
 <20181013085326.gx6rvgqbbyuntfvv@ryuk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181013085326.gx6rvgqbbyuntfvv@ryuk>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Aleksa Sarai <asarai@suse.de>, Jann Horn <jannh@google.com>, "Eric W. Biederman" <ebiederm@xmission.com>, jlayton@kernel.org, Bruce Fields <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, christian@brauner.io, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, dev@opencontainers.org, containers@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Sat, Oct 13, 2018 at 07:53:26PM +1100, Aleksa Sarai wrote:

> I didn't know about path_is_under() -- I just checked and it appears to
> not take &rename_lock? From my understanding, in order to protect
> against the rename attack you need to take &rename_lock (or check
> against &rename_lock at least and retry if it changed).
> 
> I could definitely use path_is_under() if you prefer, though I think
> that in this case we'd need to take &rename_lock (right?). Also is there
> a speed issue with taking the write-side of a seqlock when we are just
> reading -- is this more efficient than doing a retry like in __d_path?

???

1) it uses is_subdir(), which does deal with rename_lock
2) what it does is taking mount_lock.lock.  I.e. the same
thing as the second retry in __d_path().  _If_ it shows
up in profiles, we can switch it to read_seqbegin_or_lock(),
but I'd like to see the profiling data first.
