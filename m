From: Kyle Moffett <kyle@moffetthome.net>
Subject: Re: [PATCH 3/3] p9auth: add p9auth driver
Date: Thu, 22 Apr 2010 00:57:03 -0400
Message-ID: <w2wf73f7ab81004212157o371c5738o10c8b6ff807ba36a@mail.gmail.com>
References: <20100421012749.GA21338@us.ibm.com> <20100421012908.GB24251@us.ibm.com>
	<20100421102739.6ad932fb@lxorguk.ukuu.org.uk> <20100421133917.GB16326@us.ibm.com>
	<20100421151917.5ae20265@lxorguk.ukuu.org.uk> <20100421150900.GB31880@us.ibm.com>
	<m11ve81usw.fsf@fess.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <m11ve81usw.fsf@fess.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, lkml <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Ashwin Ganti <ashwin.ganti@gmail.com>, Greg KH <greg@kroah.com>, rsc@swtch.com, ericvh@gmail.com, linux-security-module@vger.kernel.org, Ron Minnich <rminnich@gmail.com>, jt.beard@gmail.com, Andrew Morton <akpm@linux-foundation.org>, Andrew Morgan <morgan@kernel.org>, oleg@us.ibm.com, Eric Paris <eparis@redhat.com>, linux-api@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>
List-Id: linux-api@vger.kernel.org

On Wed, Apr 21, 2010 at 15:15, Eric W. Biederman <ebiederm@xmission.com=
> wrote:
> "Serge E. Hallyn" <serue@us.ibm.com> writes:
>
>> Ignoring namespaces for a moment, I guess we could do something like
>>
>> struct credentials_pass {
>> =C2=A0 =C2=A0 =C2=A0 pid_t global_pid;
>> =C2=A0 =C2=A0 =C2=A0 unsigned long unique_id;
>> =C2=A0 =C2=A0 =C2=A0 uid_t new_uid;
>> =C2=A0 =C2=A0 =C2=A0 gid_t new_gid;
>> =C2=A0 =C2=A0 =C2=A0 int num_aux_gids;
>> =C2=A0 =C2=A0 =C2=A0 gid_t aux_gids[];
>> }
>
> This looks surprising like what I am doing in passing uids and pids
> through unix domain sockets.
>
> So if this looks like a direction we want to go it shouldn't be too
> difficult.

Hmm... for an alternative idea:

We have this nice "kernel keyring" infrastructure that lets us stuff
arbitrary things into "keys" and grant/revoke them between processes.
What if we created a relatively generic way for processes to package
up privileges (of whatever form) into a "key" that could be granted to
another process (via UNIX-domain socket)?  Then the other process
would use a setuid()-ish syscall which would instead apply a specific
key as your credentials, possibly including the audit context and/or
namespaces it came from.

By using the keyring system, such tokens could be kept around across
multiple processes easily (as opposed to FDs), in the same style as a
"sudo" ticket file, for example (even with an expiration time).

Types of credentials you could pass around:
  * Capabilities
  * Filesystem UID/GID in a particular UID namespace (for FS operations=
)
  * Process UID/GID in a particular UID namespace (for kill(), etc)
  * Audit contexts
  * SELinux/etc security labels

All of the above could be optionally limited to effectively require a
bprm-secure-style exec() with specific args.  So for example, instead
of making "/usr/sbin/passwd" a setuid program, you could make it be an
unprivileged helper.  It would connect to a privileged daemon and ask
for a password-change cookie for that particular user.  The daemon
would create what is essentially a "delayed exec" key which grants a
specific UID and capabilities when that process performs an execkey().

So as an example, you could rewrite "sudo" as a partially-privileged
daemon and an unprivileged helper.  The unpriv helper would send
across a request (optionally including the command and environment)
which would be checked by the daemon.  It would then issue a key to
allow the unpriv helper to perform a limited exec.

Another option would be to rewrite network login programs (eg OpenSSH)
to use this for privilege separation.  The listening process would get
a non-expiring key to allow it to exec a partially-privileged
password-checking program.  If the password-checking program likes the
password it generates a single-use key to pass back to the forked
network process that allows it to exec a program as that user.

Cheers,
Kyle Moffett
