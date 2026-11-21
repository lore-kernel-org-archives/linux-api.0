Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795233157;
	b=u02EDWcuhaWMiGluK7JhIrX3XlhEauyzuL5T7pEKwuvvGQgyEq5glHM+xXjUVsadKPah
	 Jr41kLOHl507ss6k0zgLLpdiI+WKQc64ay7DuKRSFPvnOOjRrUHAyTqN9ox8Oni8IlUJ6
	 5IehU7O+4AD4FvSkj8AC0EVAZJCraQGCDGVsFZqLi1DqqeYHjgWgONh1ey0dREwzNRZkJ
	 WT7omtOW8pZxsYZmCsxN/DYOr2j7ZemHF3fw8y2LS479k6W+auP9nFmk6n7fO3MNc6IMG
	 7gD2BNuFg9WzGVXX5n+E/myeBuzlQZCUiRt8q72XNRqd4JBBQnQu7e1qV6y9+WclOMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795233157;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=zIDk71Ax+oCdiiIjTS8sKBRujsFJoxCyGBXFurjsjm8=;
	b=pdgp6/ELUHNBhHB7W5ImZrZZz9O6T17QUThoFgcItMDwGwrrJe0VQyCVyatS0OgEsaBK
	 thI5GiqDJjg4BnJd8b544avMxXxmo9ewdU6dx6sgMWajqxirjhPVsYa6lKmP+EidE3GLz
	 nzgE9SwLym8RymgIprPrF1Bicve5/nV8vmycou1fb+ehYsWLOZSCsJtWPKxRYcGettUSt
	 oojx90mumnzOqjdfgEtabBqYaJDWCNF/LZkjZ9j+Wfz+A7ugJi60OR8xGIAfeuUo1RCse
	 T1Hq/+Z5NFNFTn4MHlT+zlzwkGpMHTMIfsX7I7DF7T5537fimRVgUWSIRIEy1JUC6+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=GzmoljCk;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Bdj4+7rG;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957A9606A6A0
	for <linux-api@vger.kernel.org>; Sat, 21 Nov 2026 03:52:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 957A9606A6A0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=GzmoljCk;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Bdj4+7rG
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AL0ggbW049654
	for <linux-api@vger.kernel.org>; Sat, 21 Nov 2026 03:52:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=zIDk71Ax+oCdiiIjTS8sKBRu
	jsFJoxCyGBXFurjsjm8=; b=GzmoljCk11fmune989tg3EQ+1KooQ4eiUnNITPK0
	ksIdXiwn7nxZQBKPCCUsy6jmg7OOZSKOuVlQYIy1fCAn4vbPLMI90WaSGs9y32qw
	JxRR4k3o0Sjp8XdeGQ1XA/LSDykWwhuLZNPXC4KL7qCdhAHLGhHR4e9fxgcxRHbf
	7Y/CMk8VSW1c6zFak0z3HrCxontXpkdhqjLSyKJcw77IWLB1wRLV1BHPL6z3UqJn
	w1KritOYE+EZ/BdHnUnEPC9aU/mLzsnCtPh8Z1fTp5csINBaXrQz5hasVoGQjGma
	hrixnHuo6kRf5e74TRPtt5f41NcyKkcs4SYFrdY33NCYqQ==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4j310f8c97-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-api@vger.kernel.org>; Sat, 21 Nov 2026 03:52:32 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-341eff9e381so2457871eec.1
        for <linux-api@vger.kernel.org>; Fri, 20 Nov 2026 19:52:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1795233152; x=1795837952; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zIDk71Ax+oCdiiIjTS8sKBRujsFJoxCyGBXFurjsjm8=;
        b=Bdj4+7rGFUlTYMnIoAd6fUZ8ApFm0NCSTOKONEOxZU6gdQh7+rT2W2b/lb0eifRQ7q
         3IkohNT2siHJZZxygrB8ZgcyzCv/L9JAZlYiMhlxqdBzaBtesmWIJWg80KqfnVND5gIM
         qu5z4ZI76llpK5NHOfJ6rXLgTcAIu+9b7ly7Um9sEk2FTZMiLU5jWE7AODtmcCxd2BF0
         vITBThcOF2IsbLBmS4yWSYPOxp4n1PwZPp6fDpx0c/tMHhYfhXbHg85whKQK/oZByNio
         TDoy2WfXbzlUm4JbghPl/E4e6fVtg14v5k4hDhyD+x27hdPmKDJHlboMNasc7H07yRkB
         zdeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795233152; x=1795837952;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zIDk71Ax+oCdiiIjTS8sKBRujsFJoxCyGBXFurjsjm8=;
        b=Kz64GeJeVaRt2yMZ4LRUhiDaNXbCrr1d0HBs+zYZHjpnSOCnczsc1QnjWSGZvHtbnr
         Mh/LN9aqUN2DZfytRJ8pUUP1ZXbCxgCXBB0MjPnzslOy3BbZqk7lfelEIBo0DV0ENxY2
         da+1MIM52v5Vxp/+1dQswxfasdyuh5L8QFjm4FfaEARzT3uq0IXcbSMVGTHbPXtRLk8o
         sAzPGjYgxT+zTpvpn5B7d/Ygbtexuypd1+waWUstTyXt4dQcIBTxoWq9IbjxNDSOT249
         VuzfsXzGcIwJmHY7i+SlJKIoC1IFnfldq6b9V3ln54r4SperzMWIU2Veo3P6ijmTyVi+
         sDpg==
X-Forwarded-Encrypted: i=1; AL+hErFoc+SIGmRMRPLMrZoxnuUNZnm8WKld/9juA7k6fhVpH53q+WwyDhvMJSr4KoBukeJxYX+2cti5Pdc=@vger.kernel.org
X-Gm-Message-State: APuU4Z9NJVNkdDJga7SN59wIuioeufIpaQPPJA5w2Xsn91aaEihIN7bS
	kZY+3aeW3e4cEcgcN7LuMaUbyKFsuKdXf8eoGpreyoUekl2mfPXX0JdKRti74uTW5eEXtt2otcZ
	7IUMzzdr6UNVewW8Q1/An8Xc31pav1oO+Tr0SJLCUXauCYd7L0A+KYY23/r/zA/4=
X-Gm-Gg: AZFdTZeB0/ZINe0cA73FAyaYbY5Mkahe18PXZGYoy7zPlt82uZwxiJLRMFVbhW95Ild
	T7yNPUO4lwGU8Zj/wW6wBhazTDkbDwGpJxNb3S105LMLWZVHWr6QEu0unKuR9Nl+zgCK1Wy+3+v
	KG1+d8UHF7UrFejnKrJzQv3RjpTeIk9gPdftKFsSS4kooZUXGTJoUuxsAJNw8vz3mno7XQu7olG
	bnUcr93KQlqnIuqIang8kfLoT472fAPl0NEBVMH4vk3aA6ARlxjE1lMGvaZz5pzgqCMHACeGaBN
	sZO8X5aHblH1meYBN957EZ9c4lQUVni5icS9dfrs0rIiMA+f3f03rzU9rUni7H/n5Js052sNPZc
	AgiRQy+7EdJ6sFrLMgOxRtBxmP2mMgINCRUQ48GleQ5UmwQppD5EK9gzGkPdItkNv1xoZfsI0Mx
	nKUJtab1w4idAFDvriG+CS2Fw=
X-Received: by 2002:a05:693c:4195:10b0:385:2c71:7539 with SMTP id 5a478bee46e88-3856f258aa5mr5504185eec.9.1795233152028;
        Fri, 20 Nov 2026 19:52:32 -0800 (PST)
X-Received: by 2002:a05:693c:4195:10b0:385:2c71:7539 with SMTP id 5a478bee46e88-3856f258aa5mr5504128eec.9.1795233151382;
        Fri, 20 Nov 2026 19:52:31 -0800 (PST)
Received: from hu-ashoraj-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385666e99fdsm16134963eec.5.2026.11.20.19.52.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 19:52:30 -0800 (PST)
Date: Fri, 20 Nov 2026 19:52:28 -0800
From: Ashok Raj <ashok.raj@oss.qualcomm.com>
To: Ahmed Azeem <ahmed.azeem@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Sudeep Holla <sudeep.holla@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>, linux-api@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Divin Raj <divin.raj@arm.com>,
        Bertrand Marquis <Bertrand.Marquis@arm.com>,
        Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
        Ashok Raj <ashok.raj@oss.qualcomm.com>
Subject: Re: [PATCH RFC 3/4] firmware: arm: Add PFDI run, result, and error
 injection support
Message-ID: <awEVfD12XgmNhqxt@hu-ashoraj-lv.qualcomm.com>
References: <20261119-topics-ahmaze01-upstream-pfdi-rfc-v1-0-4772d18b9115@arm.com>
 <20261119-topics-ahmaze01-upstream-pfdi-rfc-v1-3-4772d18b9115@arm.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261119-topics-ahmaze01-upstream-pfdi-rfc-v1-3-4772d18b9115@arm.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIxMDAxNSBTYWx0ZWRfX0GDEHjpjCZwp
 DdVXZEvXe2KxoPxli7r7NSjJbkIDo43n8Vc6rD8mCZjiUDupmrPwubKNdjZbxqGXStjaEpnb80M
 QB9k8sJmhV6j/CtjRmo9Y2ej1GaKU/BgefDatHIu5KsVwg/0dAERf78fINX2AoWZ824GEC5amvb
 CVpVPoB3EdyD+gPOoFhWSoJR141t/iBCYi5yC5pqDcf78GNN9+ze4X5IyxS4mYsOsYMIu6u+lB5
 a7brNUN5CxG7ywYbVRQrTBJ3gdvKBK5nPsaQ3lfVSW6tPOV8iWxg5nMjxuqGiN/Z7HxEoZbDUY/
 b6DOolZqsYJriswbqrRmUDZr4wepTakenSN8egSBVmtTrN+kYKxP55ZD90I3AxK8/6eTEQrrNPv
 1csW2djmg9uPAkt/i6ExZZm3UweFYJbRN4HoQ86QpbwiQ/chawZkwA3exNGe0Ah8gXwMiGczTt7
 djm1hCXiR78K5wqWqow==
X-Proofpoint-ORIG-GUID: DkLeQWvGd9rI2JAEKevgcRWPK28t-bvh
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIxMDAxNSBTYWx0ZWRfXynoTr/R442QN
 XCY4p1JFsMZm8GhiIL6N64VNzIAP9ePhtxLgjFaOFG5o3Q0OSik/i/o4enZEb/KmBbPdU19lUbm
 wnJlMOIDJerlHqvod9qiE4lMhtDB78Q=
X-Proofpoint-GUID: DkLeQWvGd9rI2JAEKevgcRWPK28t-bvh
X-Authority-Analysis: v=2.4 cv=UN1Ijyfy c=1 sm=1 tr=0 ts=6b011580 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=7CQSdrXTAAAA:8 a=hGlcRQhp3Xgnm4JraE4A:9 a=QEXdDO2ut3YA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-20_06,2026-11-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 clxscore=1011 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 adultscore=0 suspectscore=0 bulkscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611210015

On Thu, Nov 19, 2026 at 03:36:05PM +0000, Ahmed Azeem wrote:
> From: Divin Raj <divin.raj@arm.com>
> 
> Extend the PFDI driver with ioctls to execute tests and manage results.
> 
> Add support for PFDI_IOCTL_PE_TEST_RUN, PFDI_IOCTL_PE_TEST_RESULT, and
> PFDI_IOCTL_FORCE_ERROR, along with per-CPU state to serialize test
> execution. When firmware reports PFDI_RET_FAULT_FOUND, return the
> failing test identifier to userspace.
> 
> Signed-off-by: Divin Raj <divin.raj@arm.com>
> Signed-off-by: Ahmed Azeem <ahmed.azeem@arm.com>
> ---
>  drivers/firmware/arm_pfdi.c | 225 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 225 insertions(+)
> 
> diff --git a/drivers/firmware/arm_pfdi.c b/drivers/firmware/arm_pfdi.c
> index 8c6d315b0572..22a69b12dbc8 100644
> --- a/drivers/firmware/arm_pfdi.c
> +++ b/drivers/firmware/arm_pfdi.c
> @@ -18,10 +18,16 @@
>  #include <linux/slab.h>
>  #include <linux/smp.h>
>  #include <linux/uaccess.h>
> +#include <linux/wait.h>
>  
>  struct pfdi_per_cpu_info {
> +	atomic_t run_inprogress;
>  	/* Ensures a single userspace owner per CPU while the node is open. */
>  	struct semaphore open_sem;
> +	/* Serializes per-CPU run state and device availability. */
> +	struct mutex state_lock;
> +	struct pfdi_test_range ongoing_run_range;
> +	wait_queue_head_t run_wait;
>  };
>  
>  struct pfdi_dev_data {
> @@ -36,6 +42,8 @@ struct pfdi_cpu_worker {
>  	u32 feature_fid;
>  	/* Protects worker lifetime and in-flight work state. */
>  	struct mutex worker_lock;
> +	struct pfdi_force_error error_info;
> +	struct pfdi_test_run test_run;
>  	struct arm_smccc_res smc_ret;
>  	int result;
>  };
> @@ -59,6 +67,10 @@ static DEFINE_PER_CPU(struct pfdi_per_cpu_info, pfdi_cpu_info);
>  
>  static enum cpuhp_state pfdi_cpuhp_state;
>  
> +static unsigned int pfdi_wait_timeout_ms = 60;
> +module_param_named(wait_timeout_ms, pfdi_wait_timeout_ms, uint, 0444);
> +MODULE_PARM_DESC(wait_timeout_ms,
> +		 "Maximum time in ms to wait for an in-progress PFDI run");
>  static int pfdi_to_linux_errno(int err)
>  {
>  	switch (err) {
> @@ -95,6 +107,18 @@ static int pfdi_smc_feature(u32 smc_fid)
>  	return (int)pfdi_smc_call(PFDI_FN_FEATURES, smc_fid, 0, 0, 0).a0;
>  }
>  
> +static bool pfdi_fid_supported(u32 smc_fid)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(pfdi_supported_fids); i++) {
> +		if (pfdi_supported_fids[i] == smc_fid)
> +			return true;
> +	}
> +
> +	return false;
> +}
> +
>  static int pfdi_validate_cpu_features(void)
>  {
>  	unsigned int i;
> @@ -275,6 +299,172 @@ static int pfdi_pe_fw_check(unsigned int cpu)
>  	return pfdi_to_linux_errno(per_cpu(pfdi_worker_ctx, cpu).result);
>  }
>  
> +static void pfdi_pe_get_result_fn(struct kthread_work *work)
> +{
> +	struct pfdi_cpu_worker *worker_ctx;
> +
> +	worker_ctx = container_of(work, struct pfdi_cpu_worker, work);
> +	worker_ctx->smc_ret = pfdi_smc_call(PFDI_FN_PE_TEST_RESULT,
> +					    0, 0, 0, 0);
> +	complete(&worker_ctx->done);
> +}
> +
> +static int pfdi_pe_get_result(unsigned int cpu, s64 *ft_id)
> +{
> +	int ret;
> +	struct pfdi_cpu_worker *worker_ctx = &per_cpu(pfdi_worker_ctx, cpu);
> +
> +	ret = pfdi_thread_worker(cpu, pfdi_pe_get_result_fn,
> +				 MAX_SCHEDULE_TIMEOUT);
> +	if (ret)
> +		return ret;
> +
> +	ret = (int)worker_ctx->smc_ret.a0;
> +	if (ret == PFDI_RET_FAULT_FOUND)
> +		*ft_id = worker_ctx->smc_ret.a1;
> +
> +	return pfdi_to_linux_errno(ret);
> +}
> +
> +static void pfdi_pe_force_error_fn(struct kthread_work *work)
> +{
> +	struct pfdi_cpu_worker *worker_ctx;
> +
> +	worker_ctx = container_of(work, struct pfdi_cpu_worker, work);
> +	worker_ctx->result = pfdi_smc_call(PFDI_FN_FORCE_ERROR,
> +					   worker_ctx->error_info.smc_fid,
> +					   worker_ctx->error_info.error_id,
> +					   0, 0).a0;
> +	complete(&worker_ctx->done);
> +}
> +
> +static int pfdi_pe_force_error(unsigned int cpu,
> +			       const struct pfdi_force_error *error_info)
> +{
> +	int ret;
> +	struct pfdi_cpu_worker *worker_ctx = &per_cpu(pfdi_worker_ctx, cpu);
> +
> +	if (!pfdi_fid_supported(error_info->smc_fid))
> +		return -EINVAL;
> +
> +	if (error_info->error_id < PFDI_RET_TEST_COUNT_ZERO ||
> +	    error_info->error_id > SMCCC_RET_SUCCESS)
> +		return -EINVAL;
> +
> +	worker_ctx->error_info = *error_info;
> +
> +	ret = pfdi_thread_worker(cpu, pfdi_pe_force_error_fn,
> +				 MAX_SCHEDULE_TIMEOUT);
> +	if (ret)
> +		return ret;
> +
> +	return pfdi_to_linux_errno(worker_ctx->result);
> +}
> +
> +static bool pfdi_ranges_equal(const struct pfdi_test_range *lhs,
> +			      const struct pfdi_test_range *rhs)
> +{
> +	return lhs->start == rhs->start && lhs->end == rhs->end;
> +}
> +
> +static bool pfdi_run_available(const struct pfdi_per_cpu_info *cpu_info)
> +{
> +	return !atomic_read(&cpu_info->run_inprogress);
> +}
> +
> +static int pfdi_validate_test_range(unsigned int cpu,
> +				    const struct pfdi_test_range *range)
> +{
> +	s64 count;
> +	int ret;
> +
> +	if (range->start == -1 || range->end == -1)
> +		return pfdi_ranges_equal(range,
> +					 &(struct pfdi_test_range){ .start = -1,
> +								    .end = -1 }) ?
> +		       0 : -EINVAL;
> +
> +	if (range->start < 0 || range->end < 0 || range->start > range->end)
> +		return -EINVAL;
> +
> +	ret = pfdi_pe_get_test_count(cpu, &count);
> +	if (ret)
> +		return ret;
> +
> +	if (range->start >= count || range->end >= count)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static void pfdi_pe_run_fn(struct kthread_work *work)
> +{
> +	struct arm_smccc_res smc_ret;
> +	struct pfdi_cpu_worker *worker_ctx;
> +
> +	worker_ctx = container_of(work, struct pfdi_cpu_worker, work);
> +	smc_ret = pfdi_smc_call(PFDI_FN_PE_TEST_RUN,
> +				worker_ctx->test_run.range.start,
> +				worker_ctx->test_run.range.end, 0, 0);
> +
> +	if ((int)smc_ret.a0 == PFDI_RET_FAULT_FOUND)
> +		worker_ctx->test_run.ft_id = smc_ret.a1;
> +
> +	worker_ctx->result = (int)smc_ret.a0;
> +	complete(&worker_ctx->done);
> +}
> +
> +static int pfdi_pe_run_tests(unsigned int cpu, struct pfdi_test_run *test_run)
> +{
> +	int ret;
> +	unsigned long wait_timeout;
> +	struct pfdi_cpu_worker *worker_ctx = &per_cpu(pfdi_worker_ctx, cpu);
> +	struct pfdi_per_cpu_info *cpu_info = &per_cpu(pfdi_cpu_info, cpu);
> +
> +	ret = pfdi_validate_test_range(cpu, &test_run->range);
> +	if (ret)
> +		return ret;
> +
> +	wait_timeout = msecs_to_jiffies(pfdi_wait_timeout_ms);
> +
> +	mutex_lock(&cpu_info->state_lock);
> +	while (atomic_read(&cpu_info->run_inprogress)) {
> +		if (pfdi_ranges_equal(&test_run->range,
> +				      &cpu_info->ongoing_run_range)) {
> +			mutex_unlock(&cpu_info->state_lock);
> +			return -EBUSY;
> +		}
> +
> +		mutex_unlock(&cpu_info->state_lock);
> +			ret = wait_event_interruptible_timeout(cpu_info->run_wait,
> +							       pfdi_run_available(cpu_info),
> +							       wait_timeout);
> +		if (ret <= 0)
> +			return ret ? ret : -ETIME;
> +
> +		mutex_lock(&cpu_info->state_lock);
> +	}
> +
> +	atomic_set(&cpu_info->run_inprogress, 1);
> +	cpu_info->ongoing_run_range = test_run->range;
> +	worker_ctx->test_run = *test_run;
> +	mutex_unlock(&cpu_info->state_lock);
> +
> +	ret = pfdi_thread_worker(cpu, pfdi_pe_run_fn, wait_timeout);
> +
> +	mutex_lock(&cpu_info->state_lock);
> +	if (worker_ctx->result == PFDI_RET_FAULT_FOUND)
> +		test_run->ft_id = worker_ctx->test_run.ft_id;
> +	atomic_set(&cpu_info->run_inprogress, 0);
> +	wake_up_all(&cpu_info->run_wait);
> +	mutex_unlock(&cpu_info->state_lock);
> +
> +	if (ret)
> +		return ret;
> +
> +	return pfdi_to_linux_errno(worker_ctx->result);
> +}
> +
>  static int arm_pfdi_open(struct inode *inode, struct file *file)
>  {
>  	struct miscdevice *misc_dev = file->private_data;
> @@ -310,9 +500,12 @@ static long arm_pfdi_ioctl(struct file *file, unsigned int cmd,
>  	u32 feature_fid;
>  	u32 version;
>  	s64 count;
> +	s64 ft_id;
>  	u64 lib_info;
>  	struct miscdevice *misc_dev = file->private_data;
>  	struct pfdi_dev_data *device_data;
> +	struct pfdi_test_run test_run;
> +	struct pfdi_force_error error_info;
>  	unsigned int cpu;
>  
>  	if (!misc_dev || !misc_dev->this_device)
> @@ -350,9 +543,35 @@ static long arm_pfdi_ioctl(struct file *file, unsigned int cmd,
>  					 sizeof(count)))
>  			err = -EFAULT;
>  		break;
> +	case PFDI_IOCTL_PE_TEST_RUN:
> +		if (copy_from_user(&test_run, (void __user *)arg,
> +				   sizeof(test_run)))
> +			return -EFAULT;
> +
> +		err = pfdi_pe_run_tests(cpu, &test_run);
> +		if (err == -EFAULT &&
> +		    copy_to_user((void __user *)arg, &test_run,
> +				 sizeof(test_run)))
> +			err = -EFAULT;
> +		break;

Hi Ahmed, Divin,

One UAPI concern with PFDI_IOCTL_PE_TEST_RUN is the use of -EFAULT
to represent PFDI_RET_FAULT_FOUND.

The ioctl returns -EFAULT when copy_from_user() cannot read the request,
and when copy_to_user() cannot write the failing test-part ID.  It also
returns -EFAULT when the PFDI test completed and firmware reported
PFDI_RET_FAULT_FOUND.

This leaves userspace unable to distinguish a bad request/result pointer
from a completed test that detected a platform fault.  In the latter case,
the failing test-part ID is meaningful, while in the former case it is not.

Could the test outcome instead be returned explicitly in the request/result
structure, with ft_id valid when the reported PFDI result is
PFDI_RET_FAULT_FOUND?  The ioctl return value could then remain reserved
for Linux-side failures such as an inaccessible userspace buffer, an
interrupted wait, or device removal.

Apart from avoiding the overloaded meaning of -EFAULT, this would give the
new UAPI a natural place to reserve flags and result fields for future
extension.

Hope this helps. 

> +	case PFDI_IOCTL_PE_TEST_RESULT:
> +		err = pfdi_pe_get_result(cpu, &ft_id);
> +		if (err == -EFAULT && copy_to_user((void __user *)arg, &ft_id,
> +						   sizeof(ft_id)))
> +			err = -EFAULT;
> +		break;
>  	case PFDI_IOCTL_FW_CHECK:
>  		err = pfdi_pe_fw_check(cpu);
>  		break;
> +	case PFDI_IOCTL_FORCE_ERROR:
> +		if (copy_from_user(&error_info, (void __user *)arg,
> +				   sizeof(error_info)))
> +			return -EFAULT;
> +		if (error_info.reserved)
> +			return -EINVAL;
> +
> +		err = pfdi_pe_force_error(cpu, &error_info);
> +		break;
>  	default:
>  		err = -ENOTTY;
>  		break;


Cheers,
Ashok
