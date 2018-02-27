From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH bpf-next v8 01/11] fs,security: Add a security blob to
 nameidata
Date: Tue, 27 Feb 2018 00:57:21 +0000
Message-ID: <20180227005721.GK30522@ZenIV.linux.org.uk>
References: <20180227004121.3633-1-mic@digikod.net>
 <20180227004121.3633-2-mic@digikod.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180227004121.3633-2-mic@digikod.net>
Sender: linux-kernel-owner@vger.kernel.org
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, Andy Lutomirski <luto@amacapital.net>, Arnaldo Carvalho de Melo <acme@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, "Eric W . Biederman" <ebiederm@xmission.com>, James Morris <james.l.morris@oracle.com>, Jann Horn <jann@thejh.net>, Jonathan Corbet <corbet@lwn.net>, Michael Kerrisk <mtk.manpages@gmail.com>, Kees Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>, Thomas Graf <tgraf@suug.ch>, Tycho Andersen <tycho@tycho.ws>
List-Id: linux-api@vger.kernel.org

On Tue, Feb 27, 2018 at 01:41:11AM +0100, Mickaël Salaün wrote:
> The function current_nameidata_security(struct inode *) can be used to
> retrieve a blob's pointer address tied to the inode being walk through.
> This enable to follow a path lookup and know where an inode access come
> from. This is needed for the Landlock LSM to be able to restrict access
> to file path.
> 
> The LSM hook nameidata_free_security(struct inode *) is called before
> freeing the associated nameidata.

NAK.  Not without well-defined semantics and "some Linux S&M uses that for
something, don't ask what" does not count.
