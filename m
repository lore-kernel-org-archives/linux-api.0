From: "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH] acpi: drop support for force_remove
Date: Tue, 11 Apr 2017 15:54:43 +0200
Message-ID: <CAJZ5v0hzv1oxpNJvSc2omqaOFRgiBB8UKCbRKGkgzHbEtqosbQ@mail.gmail.com>
References: <20170403074023.29121-1-mhocko@kernel.org> <20170410171343.GO4618@dhcp22.suse.cz>
 <3644128.Y1GtXNQdkv@aspire.rjw.lan> <20170411122016.GK6729@dhcp22.suse.cz>
 <CAJZ5v0hhoej=FoqYaBOwy1-_AP35WyEYYUNkb3Pn22G0monanA@mail.gmail.com> <20170411135233.GO6729@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20170411135233.GO6729@dhcp22.suse.cz>
Sender: linux-acpi-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Joey Lee <jlee@suse.com>, Jiri Kosina <jkosina@suse.cz>, Kani Toshimitsu <toshi.kani@hpe.com>, Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Apr 11, 2017 at 3:52 PM, Michal Hocko <mhocko@kernel.org> wrote:
> On Tue 11-04-17 15:48:04, Rafael J. Wysocki wrote:
>> On Tue, Apr 11, 2017 at 2:20 PM, Michal Hocko <mhocko@kernel.org> wrote:
>> > On Tue 11-04-17 00:15:42, Rafael J. Wysocki wrote:
> [...]
>> >> I'll apply it if nobody has any problems with it.
>> >
>> > It is definitely your call but how long are we going to wait
>> > (considering that the current behavior is obviously broken wrt memory
>> > hotplug)?
>>
>> A couple of days more?  Surely not going to push it into 4.11 at this
>> stage as it is an ABI change.
>
> Ohh, I didn't want to push it to 4.11 this late but having it in
> linux-next might help to catch some users who are not following the
> mailing list. Going to 4.12 would be really great but I wouldn't really
> object even 4.13...

4.12 is probably fine.  I don't see a compelling reason to sit on this
for a whole cycle, FWIW.

Thanks,
Rafael
