# A/B and ANOVA Test  
Statistical testing on randomly generated conversion data.

## 1. Problem Setup

We are testing whether **conversion rate differs between group A and group B**.

**Hypotheses**
- **H₀:** conversion_A = conversion_B  
- **H₁:** conversion_A < conversion_B  
(One-sided test)

**Significance level:** α = 0.05

The dataset was generated so that **group B has a +1.5% higher conversion rate**, so significance is expected.

---

## 2. t-test Results

A standard independent two-sample *t-test* was applied.

- **p-value = 0.003**, which is below α  
➡️ We **reject H₀** and conclude that conversions differ.

**Type II error (β):** ~0.21  
**Power:** ~0.79  

---

### 3.1 ANOVA test (HSD)

| Comparison | diff | lwr | upr | p adj |
|-----------|------|------|------|--------|
| **B − A** | **1.573** | 0.200 | 2.947 | **0.0248** |

➡️ B has **+1.57 percentage points higher** conversion, statistically significant.

---

### 3.2 Other Factors 

Below some additional examples from HSD, demonstrating that other certain factors do not show statistically significant pairwise differences:

| Factor            | Comparison              | diff      | lwr        | upr        | p adj     |
|------------------|--------------------------|-----------|------------|------------|-----------|
| device_type      | Mobile − Desktop         | 0.1377    | −1.8533    | 2.1287     | 0.9856    |
| traffic_source   | Paid − Organic           | 0.7168    | −1.2574    | 2.6911     | 0.6706    |
| time_of_day      | Morning − Afternoon      | 1.2377    | −1.3105    | 3.7860     | 0.5952    |
| group:device_type| B:Mobile − A:Desktop     | 1.6057    | −1.8743    | 5.0857     | 0.7755    |

---

## 4. Interpretation

- ✔ **t-test** confirms a statistically significant difference between A and B  
- ✔ **ANOVA** also detects a significant group effect  
- ✔ **Tukey HSD** identifies the only true difference: **group B > group A**  
- ✘ All other differences are not significant but it is okay, because probability of getting each level of the factor was equal in the data generating process.



---

