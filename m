From: Laurence Oberman <oberman.l@gmail.com>
Subject: Re: [RFC] implementing tape statistics single file vs multi-file in sysfs
Date: Sat, 7 Feb 2015 21:27:05 -0500
Message-ID: <ACE69613-157F-4516-8499-EF8242D26736@gmail.com>
References: <DDB9C85B850785449757F9914A034FCB3BF3EADA@G9W0766.americas.hpqcorp.net> <20150206125916.GB26247@kroah.com> <20150206154157.GD1143@localhost.localdomain> <20150207040743.GB29944@kroah.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20150207040743.GB29944@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "Bryn M. Reeves" <bmr@redhat.com>, "Seymour, Shane M" <shane.seymour@hp.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Kai.Makisara@kolumbus.fi" <Kai.Makisara@kolumbus.fi>, "James E.J. Bottomley (JBottomley@parallels.com)" <JBottomley@parallels.com>, "Laurence Oberman (loberman@redhat.com)" <loberman@redhat.com>
List-Id: linux-api@vger.kernel.org

Hello
Its not going to be tens of thousands of devices. That count was an
aggregate based on 1000's of servers.
In reality its unlikely to ever be more than 100 tapes drives per
individual Linux kernel instance.
Therefore sysfs will be the valid way to do this and make the data
available to user space.

Thanks
Laurence


> On Feb 6, 2015, at 11:07 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> 
>> On Fri, Feb 06, 2015 at 03:41:58PM +0000, Bryn M. Reeves wrote:
>>> On Fri, Feb 06, 2015 at 04:59:16AM -0800, Greg KH wrote:
>>>> On Fri, Feb 06, 2015 at 12:20:53AM +0000, Seymour, Shane M wrote:
>>>> The current patch that implements tape statistics is here:
>>>> 
>>>> http://marc.info/?l=linux-scsi&m=142112067313723&w=2
>>> 
>>> Aside from the "do we want to do this all in a single file" issue that I
>>> will say more on below, this patch has issues.  Please don't use a
>>> kobject for _ANYTHING_ in sysfs that has a struct device as a parent.
>>> If you do that, it can't be seen by userspace tools very well, if at
>>> all.
>> 
>> I can't speak for Shane but wouldn't spend too much time looking at the
>> current v2 patch: it's the result of a pretty ugly compromise suggested
>> on linux-scsi.
> 
> Fair enough, but please feel free to cc: me on the patch that you do
> feel is correct to get a sysfs-related review.
> 
>>>> Recently there was was another discussion here about one file vs a collection of files for tape statistics:
>>>> 
>>>> http://marc.info/?l=linux-scsi&m=142316255501550&w=2
>>>> 
>>>> The result was that I should ask here what method I should use. I
>>>> would like to get feedback in relation to tape statistics and one file
>>>> vs multi-file in sysfs. I'm happy to keep the existing code or change
>>>> to a single file approach.
>>> 
>>> One of the primary reasons we created sysfs and the "one value per file"
>>> rule is that multi-value files just do not work well.  Yes, you get an
>>> atomic snapshot, and you save some open/read/close syscall roundtrips,
>>> but you do so at the expense of forcing userspace to "know" what the
>>> format of the file is.  And once you create it, you can NEVER CHANGE IT
>>> AGAIN.
>> 
>> I am not convinced this is a concern for tape statistics: they are pretty
>> much a solved problem. The commercial *nixes have had this for decades.
>> 
>> Likewise for disk stats: although fluff like maj:min/name etc. has been
>> shuffled a few times the basic fields have remained unchanged for a very
>> long time and sysfs already removes the need to include an identity
>> field.
> 
> We already handle i/o stats just fine, why create a special sysfs
> interface for just a tape device interface?  What makes them so special?
> 
>>> Yes, that's right, if you come up with some new statistic in the future,
>>> or realize that one of the ones you have now is wrong, you can't change
>>> it, you have to make a whole new file, otherwise you could break
>>> userspace tools.
>> 
>> I understand the fact that you can't change them; I just don't think it's
>> a big problem in this specific case (and much less than some of the
>> more imaginative sysfs content - 2d int arrays with column headers
>> anyone?).
> 
> What sysfs file is a 2d int array?  I'll be glad to fix it.
> 
> Also, everyone doesn't think their solution will ever need to be
> changed.  Until later when it does :)
> 
>>> And yes, open/read/close does take take a few extra cycles, but you
>>> can't really measure it for a virtual filesystem like this on any modern
>>> system.
>> 
>> I'll try to get some numbers when I get back home next week - Shane is
>> talking about use cases involving tens of thousands of tape devices. I
>> am not certain that the overhead would be unmeasurable in that case: the
>> additional context switching & TLB flushes alone seem like they would
>> add up.
> 
> If you want to measure tens of thousands of tape devices then you
> shouldn't be using sysfs in the first place as it is not designed for
> "speed" at all.  Use the existing i/o rate interfaces instead, don't try
> to cram something into sysfs that doesn't belong there.
> 
> thanks,
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
