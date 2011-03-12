From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: [PATCH v3] introduce sys_syncfs to sync a single file system
Date: Sat, 12 Mar 2011 07:41:39 -0500
Message-ID: <4D7B6A03.9040900@gmail.com>
References: <Pine.LNX.4.64.1102171035220.13904@cobra.newdream.net>    <Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net>    <edfa4cf081249734807e582c14253fca.squirrel@webmail.greenhost.nl>    <201103111255.44979.arnd@arndb.de>    <ffafd3ccb3fd1be7c40348c9cee84aef.squirrel@webmail.greenhost.nl>    <4D7AC0FE.8070806@gmail.com>    <1d4d1b7ae64da97f44cad0e2bda4f832.squirrel@webmail.greenhost.nl>    <4D7ADFDD.9080108@gmail.com> <e118a1458c29e4f44bf71c7095e4bce8.squirrel@webmail.greenhost.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <e118a1458c29e4f44bf71c7095e4bce8.squirrel@webmail.greenhost.nl>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Indan Zupancic <indan@nul.nu>
Cc: Arnd Bergmann <arnd@arndb.de>, Sage Weil <sage@newdream.net>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>, Jonathan Nieder <jrnieder@gmail.com>, akpm@linux-foundation.org, linux-api@vger.kernel.org, mtk.manpages@gmail.com, viro@zeniv.linux.org.uk, hch@lst.de, l@jasper.es
List-Id: linux-api@vger.kernel.org

On 03/11/2011 10:50 PM, Indan Zupancic wrote:
> On Sat, March 12, 2011 03:52, Ric Wheeler wrote:
>> Sage was pretty clear in stating the motivation which is the use case you
>> think is questionable. Probably not interesting for consumer devices, but
>> definitely extremely interesting in large servers with multiple file systems.
> Not really, he just said "It is frequently useful to sync a single file system",
> without giving any use cases. He then gave two situations where either sync or
> fsync isn't sufficient, to which I replied earlier and you called missing the
> point. But that's not the same as giving a use case.
>
>> In fact, we do it today as mentioned earlier in the thread - this simply
>> exports that useful capability in a clean way.
> Did you use the remount trick or the ioctl? If the latter, is it sufficient
> for your need? If the first, would guaranteeing that mount -o remount,rw
> trick will keep working solve the problem for you?
>
> When or why would you want to sync one specific filesystem? As you're doing
> it, you could explain your use case better instead of telling me I'm missing
> the point.
>
> If sync(2) didn't exist and people wanted to add it I'd complain too. This
> has all the problems of sync(2), but with the "not sure if all the files are
> on the file system I think" problem added.
>
> Greetings,
>
> Indan

System wide sync and file system specific sync are useful in several scenarios. 
One example is something like a restore (or an rsync) where an application 
copies lots of files into a target file system. It is *much* faster to do this 
without doing an fsync() call per file (orders of magnitude faster).

Once your bulk write has finished, it is prudent to run "sync" to push that data 
out to disk before you trust that your new copy will survive a crash or power 
outage. Alternatively, you could reopen and fsync each file that was copied 
which seems to be the method that you prefer.

Ric

