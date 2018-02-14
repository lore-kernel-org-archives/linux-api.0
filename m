From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2] fs: fsnotify: account fsnotify metadata to kmemcg
Date: Wed, 14 Feb 2018 10:38:09 +0200
Message-ID: <CAOQ4uxifddquri4BNqBSKv6O_b13=C08kKYinTo9+m56z1n+aQ@mail.gmail.com>
References: <20171030124358.GF23278@quack2.suse.cz> <76a4d544-833a-5f42-a898-115640b6783b@alibaba-inc.com>
 <20171031101238.GD8989@quack2.suse.cz> <20171109135444.znaksm4fucmpuylf@dhcp22.suse.cz>
 <10924085-6275-125f-d56b-547d734b6f4e@alibaba-inc.com> <20171114093909.dbhlm26qnrrb2ww4@dhcp22.suse.cz>
 <afa2dc80-16a3-d3d1-5090-9430eaafc841@alibaba-inc.com> <20171115093131.GA17359@quack2.suse.cz>
 <CALvZod6HJO73GUfLemuAXJfr4vZ8xMOmVQpFO3vJRog-s2T-OQ@mail.gmail.com>
 <CAOQ4uxg-mTgQfTv-qO6EVwfttyOy+oFyAHyFDKTQsDOkQPyyfA@mail.gmail.com>
 <20180124103454.ibuqt3njaqbjnrfr@quack2.suse.cz> <CAOQ4uxhDpBBUrr0JWRBaNQTTaUeJ4=gnM0iij2KivaGgp1ggtg@mail.gmail.com>
 <CALvZod4PyqfaqgEswegF5uOjNwVwbY1C4ptJB0Ouvgchv2aVFg@mail.gmail.com>
 <CAOQ4uxhyZNghjQU5atNv5xtgdHzA75UayphCyQDzxjM8GDTv3Q@mail.gmail.com>
 <CALvZod5H4eL=YtZ3zkGG3p8gD+3=qnC3siUw1zpKL+128KufAA@mail.gmail.com>
 <CAOQ4uxgJqn0CJaf=LMH-iv2g1MJZwPM97K6iCtzrcY3eoN6KjA@mail.gmail.com>
 <CAOQ4uxjgKUFJ_uhyrQdcTs1FzcN6JrR_JpPc9QBrGJEU+cf65w@mail.gmail.com>
 <CALvZod45r7oW=HWH7KJyvFhJWB=6+Si54JK7E0Mx_2gLTZd1Pg@mail.gmail.com>
 <CAOQ4uxghwNg9Ni23EQA-971-qAaTNceSZS2MSvK06uEjoXG_yg@mail.gmail.com>
 <CALvZod7FTNzoGfGnaorqjk4KEsxJFdz1pApHi04P1cF10ejxpQ@mail.gmail.com> <CALvZod4SNwWHYZQsphB90cY-wc8WSLurKsA2kNxfVKV-upwy9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <CALvZod4SNwWHYZQsphB90cY-wc8WSLurKsA2kNxfVKV-upwy9A@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
To: Shakeel Butt <shakeelb@google.com>
Cc: Jan Kara <jack@suse.cz>, Yang Shi <yang.s@alibaba-inc.com>, Michal Hocko <mhocko@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Feb 14, 2018 at 3:59 AM, Shakeel Butt <shakeelb@google.com> wrote:
> On Tue, Feb 13, 2018 at 2:20 PM, Shakeel Butt <shakeelb@google.com> wrote:
[...]
>>>>> Something like FAN_GROUP_QUEUE  (better name is welcome)
>>>>> which is mutually exclusive (?) with FAN_UNLIMITED_QUEUE.
>>>>>
>>
>> How about FAN_CHARGE_MEMCG?
>>

I am not crazy about this name.
Imagine a user that writes a file system listener that is going to run
inside a container.
The user doesn't need to know about the container or what is memcg
and what is memcg charging.
IMO, we need to hide those implementation details from the user and
yet encourage user to opt-in for memcg charging... or do we?

>
> Also should there be a similar flag for inotify_init1() as well?
>

This question changed my perspective on the fanotify_init() flag.
Unlike with fanotify, for inotify, is it the sysadmin that determines
the size of the queue of future listeners by setting
/proc/sys/fs/inotify/max_queued_events

IMO, there is little justification for a program to opt-out of memcg
charging if the sysadmin opts-in for memcg charging.
Anyone disagrees with that claim?

So how about /proc/sys/fs/inotify/charge_memcg
which defaults to CONFIG_INOTIFY_CHARGE_MEMCG
which defaults to N.

Then sysadmin can opt-in/out of new behavior and distro can
opt-in for new behavior by default and programs don't need to
be recompiled.

I think that should be enough to address the concern of changing
existing behavior.

The same logic could also apply to fanotify, excpet we may want to
use sysfs instead of procfs.
The question is: do we need a separate knob for charging memcg
for inotify and fanotify or same knob can control both?

I can't think of a reason why we really need 2 knobs, but maybe
its just nicer to have the inotify knob next to the existing
max_queued_events knob.

Thanks,
Amir.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
