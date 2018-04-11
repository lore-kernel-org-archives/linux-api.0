From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Subject: Re: [PATCH 01/24] Add the ability to lock down access to the running
 kernel image
Date: Wed, 11 Apr 2018 20:50:00 +0200
Message-ID: <CANiq72n=b3ghgHzknhY=fNP9=f8fi8OuW7OPQHXQGJH_aWrT-w@mail.gmail.com>
References: <152346387861.4030.4408662483445703127.stgit@warthog.procyon.org.uk>
 <152346388583.4030.15146667041427303547.stgit@warthog.procyon.org.uk> <6a37b428-d9fb-12d5-8d36-8a032984af8c@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6a37b428-d9fb-12d5-8d36-8a032984af8c@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: David Howells <dhowells@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-man@vger.kernel.org, linux-api@vger.kernel.org, jmorris@namei.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Apr 11, 2018 at 7:37 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
> On 04/11/2018 09:24 AM, David Howells wrote:
>
>> diff --git a/security/lock_down.c b/security/lock_down.c
>> new file mode 100644
>> index 000000000000..f35ffdd096ad
>> --- /dev/null
>> +++ b/security/lock_down.c
>> @@ -0,0 +1,65 @@
>> +/* Lock down the kernel
>> + *
>> + * Copyright (C) 2016 Red Hat, Inc. All Rights Reserved.
>> + * Written by David Howells (dhowells@redhat.com)
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public Licence
>> + * as published by the Free Software Foundation; either version
>> + * 2 of the Licence, or (at your option) any later version.
>
> fsf.org spells that Licence word as License. :)

Given this is a new file, simply use the SPF identifier on top.

Cheers,
Miguel
