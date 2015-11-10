From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH selftests 5/6] selftests: vm: Try harder to allocate huge
 pages
Date: Tue, 10 Nov 2015 13:05:51 -0700
Message-ID: <56424E1F.9040507@osg.samsung.com>
References: <1446334510.2595.13.camel@decadent.org.uk>
 <1446334747.2595.19.camel@decadent.org.uk>
 <alpine.DEB.2.10.1511101159480.29993@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.10.1511101159480.29993-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 11/10/2015 01:01 PM, David Rientjes wrote:
> On Sat, 31 Oct 2015, Ben Hutchings wrote:
> 
>> If we need to increase the number of huge pages, drop caches first
>> to reduce fragmentation and then check that we actually allocated
>> as many as we wanted.  Retry once if that doesn't work.
>>
>> Signed-off-by: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
>> ---
>> The test always fails for me in a 1 GB VM without this.
>>
>> Ben.
>>
>>  tools/testing/selftests/vm/run_vmtests | 15 ++++++++++++++-
>>  1 file changed, 14 insertions(+), 1 deletion(-)
>>
>> diff --git a/tools/testing/selftests/vm/run_vmtests b/tools/testing/selftests/vm/run_vmtests
>> index 9179ce8..97ed1b2 100755
>> --- a/tools/testing/selftests/vm/run_vmtests
>> +++ b/tools/testing/selftests/vm/run_vmtests
>> @@ -20,13 +20,26 @@ done < /proc/meminfo
>>  if [ -n "$freepgs" ] && [ -n "$pgsize" ]; then
>>  	nr_hugepgs=`cat /proc/sys/vm/nr_hugepages`
>>  	needpgs=`expr $needmem / $pgsize`
>> -	if [ $freepgs -lt $needpgs ]; then
>> +	tries=2
>> +	while [ $tries -gt 0 ] && [ $freepgs -lt $needpgs ]; do
>>  		lackpgs=$(( $needpgs - $freepgs ))
>> +		echo 3 > /proc/sys/vm/drop_caches
>>  		echo $(( $lackpgs + $nr_hugepgs )) > /proc/sys/vm/nr_hugepages
>>  		if [ $? -ne 0 ]; then
>>  			echo "Please run this test as root"
>>  			exit 1
>>  		fi
>> +		while read name size unit; do
>> +			if [ "$name" = "HugePages_Free:" ]; then
>> +				freepgs=$size
>> +			fi
>> +		done < /proc/meminfo
>> +		tries=$((tries - 1))
>> +	done
>> +	if [ $freepgs -lt $needpgs ]; then
>> +		printf "Not enough huge pages available (%d < %d)\n" \
>> +		       $freepgs $needpgs
>> +		exit 1
>>  	fi
>>  else
>>  	echo "no hugetlbfs support in kernel?"
>>
> 
> I know this patch is in -mm and hasn't been merged by Linus yet, but I'm 
> wondering why the multiple /proc/sys/vm/drop_caches is helping?  Would it 
> simply suffice to put a sleep in there instead or is drop_caches actually 
> doing something useful a second time around?
> 

I sent this up for merge in my pull request. Adding sleep would increase
test run-time. Something to keep in mind.

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
