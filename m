From: "Peter Huewe" <PeterHuewe@gmx.de>
Subject: Re: [tpmdd-devel] [PATCH v10 0/8] TPM 2.0 support
Date: Tue, 16 Dec 2014 22:32:18 +0100
Message-ID: <trinity-c704c9fe-b92f-48bd-80cc-a452bd18cc28-1418765537847@3capp-gmx-bs15>
References: <1418413600-5400-1-git-send-email-jarkko.sakkinen@linux.intel.com>,
	<20141215201757.GA27923@intel.com>,
	<trinity-c582edfe-4951-4a31-911d-db0c6f723157-1418764766771@3capp-gmx-bs15>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1763522383400985834=="
Return-path: <trousers-tech-bounces@lists.sourceforge.net>
In-Reply-To: <trinity-c582edfe-4951-4a31-911d-db0c6f723157-1418764766771@3capp-gmx-bs15>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/trousers-tech>,
	<mailto:trousers-tech-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=trousers-tech>
List-Post: <mailto:trousers-tech@lists.sourceforge.net>
List-Help: <mailto:trousers-tech-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/trousers-tech>,
	<mailto:trousers-tech-request@lists.sourceforge.net?subject=subscribe>
Errors-To: trousers-tech-bounces@lists.sourceforge.net
To: Peter Huewe <PeterHuewe@gmx.de>
Cc: christophe.ricard@gmail.com, linux-api@vger.kernel.org, Ashley Lai <ashley@ashleylai.com>, linux-kernel@vger.kernel.org, josh@joshtriplett.org, tpmdd-devel@lists.sourceforge.net, jason.gunthorpe@obsidianresearch.com, trousers-tech@lists.sourceforge.net
List-Id: linux-api@vger.kernel.org

--===============1763522383400985834==
Content-Type: text/html; charset=UTF-8

<html><head></head><body><div style="font-family: Verdana;font-size: 12.0px;"><div>Hi,</div>

<div>if I fix this (already adressed issue)&nbsp;</div>

<div>
<div>&nbsp;#define TPM2_STARTUP_IN_SIZE &#92;<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (sizeof(struct tpm_input_header) + &#92;<br/>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sizeof(struct tpm2_pcr_read_in))<br/>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sizeof(struct tpm2_startup_in))</div>

<div>&nbsp;</div>

<div>it gets detected correctly.</div>

<div>&nbsp;</div>

<div>I&#39;ll fix it, no updated patch needed.</div>

<div>&nbsp;</div>

<div>Not sure however if I think to reuse tpm2_startup_in also for shutdown, simply because it has&nbsp; the same size, but ok.</div>

<div>&nbsp;</div>

<div>Peter</div>
</div></div></body></html>


--===============1763522383400985834==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Dive into the World of Parallel Programming! The Go Parallel Website,
sponsored by Intel and developed in partnership with Slashdot Media, is your
hub for all things parallel software development, from weekly thought
leadership blogs to news, videos, case studies, tutorials and more. Take a
look and join the conversation now. http://goparallel.sourceforge.net
--===============1763522383400985834==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
TrouSerS-tech mailing list
TrouSerS-tech@lists.sourceforge.net
https://lists.sourceforge.net/lists/listinfo/trousers-tech

--===============1763522383400985834==--
