package data.entities;

import java.time.ZonedDateTime;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import org.hibernate.annotations.Fetch;
import org.hibernate.annotations.FetchMode;

@Entity
@Table(name = "CriticalAccessQueries")
public class CriticalAccessQuery implements IReferenceAware, ICreationFlagsHelper {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "ConfigId")
    private Configuration config;

    @ManyToOne
    @JoinColumn(name = "SapConfigId")
    private SapConfiguration sapConfig;

    @OneToMany(mappedBy = "query", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<CriticalAccessEntry> entries = new HashSet<>();

    @Column(nullable = false)
    private boolean isArchived;

    @Column(nullable = false)
    private ZonedDateTime createdAt;

    @Column(nullable = false)
    private String createdBy;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Configuration getConfig() {
        return config;
    }

    public void setConfig(Configuration config) {
        this.config = config;
    }

    public SapConfiguration getSapConfig() {
        return sapConfig;
    }

    public void setSapConfig(SapConfiguration sapConfig) {
        this.sapConfig = sapConfig;
    }

    public Set<CriticalAccessEntry> getEntries() {
        return entries;
    }

    public void setEntries(List<CriticalAccessEntry> entries) {
        setEntries(new HashSet<>(entries));
    }

    /**
     * This setter applies the new entries while managing to handle foreign key references.
     *
     * @param entries the conditions to be set
     */
    public void setEntries(Set<CriticalAccessEntry> entries) {

        this.entries.forEach(x -> x.setQuery(null));
        this.entries.clear();
        this.entries.addAll(entries);
        adjustReferences();
    }

    public boolean isArchived() {
        return isArchived;
    }

    public void setArchived(boolean archived) {
        isArchived = archived;
    }

    public ZonedDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(ZonedDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public String getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(String createdBy) {
        this.createdBy = createdBy;
    }

    // =============================
    //          overrides
    // =============================

    /**
     * This method adjusts the foreign key references.
     */
    @Override
    public void adjustReferences() {

        // adjust entries
        entries.forEach(x -> x.setQuery(this));
    }

    @Override
    public void initCreationFlags(ZonedDateTime createdAt, String createdBy) {

        setCreatedAt(createdAt);
        setCreatedBy(createdBy);
    }

    @Override
    public String toString() {

        // TODO: implement logic
        return super.toString();
    }

}
