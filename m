From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH selftests 5/6] selftests: vm: Try harder to allocate huge
 pages
Date: Tue, 10 Nov 2015 12:01:48 -0800 (PST)
Message-ID: <alpine.DEB.2.10.1511101159480.29993@chino.kir.corp.google.com>
References: <1446334510.2595.13.camel@decadent.org.uk> <1446334747.2595.19.camel@decadent.org.uk>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="397176738-1890272663-1447185709=:29993"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1446334747.2595.19.camel-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
List-Id: linux-api@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--397176738-1890272663-1447185709=:29993
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Sat, 31 Oct 2015, Ben Hutchings wrote:

> If we need to increase the number of huge pages, drop caches first
> to reduce fragmentation and then check that we actually allocated
> as many as we wanted.  Retry once if that doesn't work.
> 
> Signed-off-by: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
> ---
> The test always fails for me in a 1 GB VM without this.
> 
> Ben.
> 
>  tools/testing/selftests/vm/run_vmtests | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/vm/run_vmtests b/tools/testing/selftests/vm/run_vmtests
> index 9179ce8..97ed1b2 100755
> --- a/tools/testing/selftests/vm/run_vmtests
> +++ b/tools/testing/selftests/vm/run_vmtests
> @@ -20,13 +20,26 @@ done < /proc/meminfo
>  if [ -n "$freepgs" ] && [ -n "$pgsize" ]; then
>  	nr_hugepgs=`cat /proc/sys/vm/nr_hugepages`
>  	needpgs=`expr $needmem / $pgsize`
> -	if [ $freepgs -lt $needpgs ]; then
> +	tries=2
> +	while [ $tries -gt 0 ] && [ $freepgs -lt $needpgs ]; do
>  		lackpgs=$(( $needpgs - $freepgs ))
> +		echo 3 > /proc/sys/vm/drop_caches
>  		echo $(( $lackpgs + $nr_hugepgs )) > /proc/sys/vm/nr_hugepages
>  		if [ $? -ne 0 ]; then
>  			echo "Please run this test as root"
>  			exit 1
>  		fi
> +		while read name size unit; do
> +			if [ "$name" = "HugePages_Free:" ]; then
> +				freepgs=$size
> +			fi
> +		done < /proc/meminfo
> +		tries=$((tries - 1))
> +	done
> +	if [ $freepgs -lt $needpgs ]; then
> +		printf "Not enough huge pages available (%d < %d)\n" \
> +		       $freepgs $needpgs
> +		exit 1
>  	fi
>  else
>  	echo "no hugetlbfs support in kernel?"
> 

I know this patch is in -mm and hasn't been merged by Linus yet, but I'm 
wondering why the multiple /proc/sys/vm/drop_caches is helping?  Would it 
simply suffice to put a sleep in there instead or is drop_caches actually 
doing something useful a second time around?
--397176738-1890272663-1447185709=:29993--
