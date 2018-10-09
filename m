From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH v3 3/3] namei: aggressively check for nd->root escape on
 ".." resolution
Date: Tue, 9 Oct 2018 18:46:41 +0200
Message-ID: <CAG48ez0TeT7=SC7rxNC6RA4ALUcqfRrewx9RYtg9PwFkmy044A@mail.gmail.com>
References: <20181009070230.12884-1-cyphar@cyphar.com> <20181009070230.12884-4-cyphar@cyphar.com>
 <CAG48ez3Ae5b20g2UquekfBNaUw1tLt4nWy2pYm-LNRMbDVpHfA@mail.gmail.com> <20181009153728.2altaqxclntvyc7b@mikami>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181009153728.2altaqxclntvyc7b@mikami>
Sender: linux-kernel-owner@vger.kernel.org
To: asarai@suse.de
Cc: cyphar@cyphar.com, Al Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, jlayton@kernel.org, Bruce Fields <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, christian@brauner.io, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, dev@opencontainers.org, containers@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 9, 2018 at 5:36 PM Aleksa Sarai <asarai@suse.de> wrote:
> On 2018-10-09, 'Jann Horn' via dev <jannh@google.com> wrote:
> > On Tue, Oct 9, 2018 at 9:03 AM Aleksa Sarai <cyphar@cyphar.com> wrote:
> > > This patch allows for AT_BENEATH and AT_THIS_ROOT to safely permit ".."
> > > resolution (in the case of AT_BENEATH the resolution will still fail if
> > > ".." resolution would resolve a path outside of the root -- while
> > > AT_THIS_ROOT will chroot(2)-style scope it). "proclink" jumps are still
> > > disallowed entirely because now they could result in inconsistent
> > > behaviour if resolution encounters a subsequent "..".
> > >
> > > The need for this patch is explained by observing there is a fairly
> > > easy-to-exploit race condition with chroot(2) (and thus by extension
> > > AT_THIS_ROOT and AT_BENEATH) where a rename(2) of a path can be used to
> > > "skip over" nd->root and thus escape to the filesystem above nd->root.
> > >
> > >   thread1 [attacker]:
> > >     for (;;)
> > >       renameat2(AT_FDCWD, "/a/b/c", AT_FDCWD, "/a/d", RENAME_EXCHANGE);
> > >   thread2 [victim]:
> > >     for (;;)
> > >       openat(dirb, "b/c/../../etc/shadow", O_THISROOT);
> > >
> > > With fairly significant regularity, thread2 will resolve to
> > > "/etc/shadow" rather than "/a/b/etc/shadow". There is also a similar
> > > (though somewhat more privileged) attack using MS_MOVE.
> > >
> > > With this patch, such cases will be detected *during* ".." resolution
> > > (which is the weak point of chroot(2) -- since walking *into* a
> > > subdirectory tautologically cannot result in you walking *outside*
> > > nd->root -- except through a bind-mount or "proclink"). By detecting
> > > this at ".." resolution (rather than checking only at the end of the
> > > entire resolution) we can both correct escapes by jumping back to the
> > > root (in the case of AT_THIS_ROOT), as well as avoid revealing to
> > > attackers the structure of the filesystem outside of the root (through
> > > timing attacks for instance).
> > >
> > > In order to avoid a quadratic lookup with each ".." entry, we only
> > > activate the slow path if a write through &rename_lock or &mount_lock
> > > have occurred during path resolution (&rename_lock and &mount_lock are
> > > re-taken to further optimise the lookup). Since the primary attack being
> > > protected against is MS_MOVE or rename(2), not doing additional checks
> > > unless a mount or rename have occurred avoids making the common case
> > > slow.
> > >
> > > The use of __d_path here might seem suspect, but on further inspection
> > > of the most important race (a path was *inside* the root but is now
> > > *outside*), there appears to be no attack potential. If __d_path occurs
> > > before the rename, then the path will be resolved but since the path was
> > > originally inside the root there is no escape. Subsequent ".." jumps are
> > > guaranteed to check __d_path reachable (by construction, &rename_lock or
> > > &mount_lock must have been taken after __d_path returned),
> >
> > "after"? Don't you mean "before"? Otherwise I don't understand what
> > you're saying here.
>
> I meant that the attacker doing the rename must've taken &rename_lock
> or &mount_lock after __d_path returns in the target process (because the
> race being examined is that the rename occurs *after* __d_path) and thus
> are guaranteed to be detected).
>
> Maybe there's a better way to phrase what I mean...

Aah, I thought you were referring to what the victim process is doing,
not what the racing attacker is doing.
