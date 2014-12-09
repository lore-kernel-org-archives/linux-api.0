From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [RFC] lsm: namespace hooks
Date: Tue, 09 Dec 2014 10:13:04 -0600
Message-ID: <871to8n6nj.fsf@x220.int.ebiederm.org>
References: <1417096866-25563-1-git-send-email-l.pawelczyk@samsung.com>
	<1417096866-25563-2-git-send-email-l.pawelczyk@samsung.com>
	<CAFLxGvzw4N4QFv5Vg1dDf9pdRe+Szbevmqn5QNwjLHN4xrokCg@mail.gmail.com>
	<1417098928.1805.15.camel@samsung.com> <54773757.8090905@nod.at>
	<1417099455.1805.17.camel@samsung.com> <54773CE7.5040303@nod.at>
	<1417101060.1805.21.camel@samsung.com>
	<87d288zm3a.fsf@x220.int.ebiederm.org>
	<1417104439.1805.25.camel@samsung.com>
	<871tooy4nc.fsf@x220.int.ebiederm.org>
	<1417109911.1805.27.camel@samsung.com>
	<1417524193.1899.2.camel@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1417524193.1899.2.camel@samsung.com> (Lukasz Pawelczyk's message
	of "Tue, 02 Dec 2014 13:43:13 +0100")
Sender: linux-security-module-owner@vger.kernel.org
To: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>, Miklos Szeredi <mszeredi@suse.cz>, Lukasz Pawelczyk <havner@gmail.com>, Oleg Nesterov <oleg@redhat.com>, David Howells <dhowells@redhat.com>, Mark Rustad <mark.d.rustad@intel.com>, Juri Lelli <juri.lelli@gmail.com>, Richard Weinberger <richard@nod.at>, Daeseok Youn <daeseok.youn@gmail.com>, Ingo Molnar <mingo@redhat.com>, Jeff Kirsher <jeffrey.t.kirsher@intel.com>, David Rientjes <rientjes@google.com>, Alex Thorlton <athorlton@sgi.com>, Matthew Dempsky <mdempsky@chromium.org>, Kees Cook <keescook@chromium.org>, Nikolay Aleksandrov <nikolay@redhat.com>, Dario Faggioli <raistlin@linux.it>, Al Viro <viro@zeniv.linux.org.uk>, James Morris <james.l.morris@oracle.com>, "open list:ABI/API" <linux-api@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>Paul Moore <p>
List-Id: linux-api@vger.kernel.org

Lukasz Pawelczyk <l.pawelczyk@samsung.com> writes:

> On czw, 2014-11-27 at 18:38 +0100, Lukasz Pawelczyk wrote:
>> Right now the major issue I see is that LSM by itself is not defined how
>> it's going to behave. It's up to a specific LSM module.
>> 
>> E.g. within the Smack namespace filling the map is a privileged
>> operation. So by tying them up you cripple the ability to create a fully
>> working user namespace as an unprivileged process.
>
> Entertaining the idea that LSM namespace would be tied to user namespace
> (as you suggested) how do you see the limitation I described above?

If they are tied it means you wind up in a situation where there are no
labels you can set.

In general setting the uid and gid maps is also a privileged operations.

I really don't know what makes sense to do with lsms and namespaces
generically, but I do know that your lsm namespace patche were awkwards
and weird and seemed to be taking things in the wrong direction.

Eric
