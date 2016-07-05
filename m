From: Seth Forshee <seth.forshee@canonical.com>
Subject: Re: [PATCH v2 review 09/11] quota: Handle quota data stored in
 s_user_ns.
Date: Tue, 5 Jul 2016 09:48:14 -0500
Message-ID: <20160705144814.GB119797@ubuntu-hedt>
References: <87ziq03qnj.fsf@x220.int.ebiederm.org>
 <20160702172035.19568-1-ebiederm@xmission.com>
 <20160702172035.19568-9-ebiederm@xmission.com>
 <87mvm03pxy.fsf_-_@x220.int.ebiederm.org>
 <20160704091100.GD5200@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160704091100.GD5200@quack2.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Jann Horn <jannh@google.com>, Linux API <linux-api@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-fsdevel@vger.kernel.org, Djalal Harouni <tixxdz@gmail.com>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 04, 2016 at 11:11:00AM +0200, Jan Kara wrote:
> On Sat 02-07-16 12:33:29, Eric W. Biederman wrote:
> > In Q_XSETQLIMIT use sb->s_user_ns to detect when we are dealing with
> > the filesystems notion of id 0.
> 
> Hum, is it really usable? Basically the tool calling Q_XSETQLIMIT would
> have to be aware of the namespace the filesystem is mounted in to be able
> to perform the desired operation (and if it gets is wrong, there's
> possibility it would just silently set the timers for some user instead of
> for all users).

Generally userspace does not need to be aware of the namespace. The user
id passed from userspace is translated based on its namespace, and if
that kqid doesn't map into s_user_ns the Q_XSETQLIM operation fails.

But it requires going to some trouble and having CAP_SYS_ADMIN towards
the relevant namespaces to give processes not in s_user_ns visibility to
the mount, so that isn't going to be a common scenario. If some user
does set up such a scenario then it doesn't seem to be asking too much
for them to be aware of the limitations.

Thanks,
Seth

